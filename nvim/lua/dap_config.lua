-- Configure our Debug Adapter Protocol settings
local dap = require("dap")
local dapui = require("dapui")
local tel_actions_state = require("telescope.actions.state")
local tel_actions = require("telescope.actions")

-- Virtual text plugin - Evaluates locals as virtual text within the buffer
-- I'm not convinced this is useful for me; set 'enabled = false' to disable
require('nvim-dap-virtual-text').setup({ enabled = false, commented = true, })

-- The main DAP UI - See :help nvim-dap-ui for options
dapui.setup()

-- Enable Telescope as a configuration picker
-- We'll configure this below
local telescope = require('telescope')
telescope.load_extension('dap')

-- We'll store the default configs in this table for merging with local configs
local default_configs = { configurations = {}, adapters = {}, }

--------------------------------------------------------------------------
-- Basic Setup
--------------------------------------------------------------------------

-- Set the paths to the available debuggers
local lldb_bin = vim.env.HOME .. '/.local/bin/lldb-vscode'
local node_bin = vim.env.HOME .. '/.nvm/versions/node/v20.11.1/bin/node'

-- NOTE: GDB MUST be built with DAP support
-- To do so, build a gdb version >= 14.0 and make sure to configure as:
--   $ ./configure --prefix=$HOME/.local/ --with-python=/usr/bin/python3
-- Be sure to install libgmp-dev, libmpfr-dev, and python3-dev before
-- running configure
local gdb_bin = vim.env.HOME .. '/.local/bin/gdb'

-- Automatically open/close the DAP UI on session start/end
dap.listeners.before.attach.dapui_config = dapui.open
dap.listeners.before.launch.dapui_config = dapui.open
dap.listeners.before.event_terminated.dapui_config = dapui.close
dap.listeners.before.event_exited.dapui_config = dapui.close

--------------------------------------------------------------------------
-- Helper Functions
--------------------------------------------------------------------------

-- Terminate the debug session and close DAP UI
local function terminate_session()
  dap.terminate()
  dapui.close()
end

-- Create a "deep" copy of the given config
-- This allows configs to be added/removed from the new table
-- without modifying the original
local function copy_dap_config(dap_config)
  local copy = { configurations = {}, adapters = {}, }
  for lang, configs in pairs(dap_config.configurations) do
    copy.configurations[lang] = {}
    for _, config in ipairs(configs) do
      table.insert(copy.configurations[lang], config)
    end
  end
  for name, config in pairs(dap_config.adapters) do
    copy.adapters[name] = config
  end
  return copy
end

-- Create a (placeholder) local dap-config.lua file from the current global config
-- Any configurations and adapters placed in this file will be shown in the Telescope
-- picker in addition to those defined in this file
local function create_starter_local_config()
  local conf = vim.fn.getcwd() .. '/dap-config.lua'
  local f = io.open(conf, 'w')
  if f == nil then
    print("ERROR: Could not create file: " .. conf)
    return
  end

  local dap_config = [[--Placehodler config - edit as needed
local dap = {
  configurations = {
    cpp = {
      -- List of config tables here
      -- Each config needs at least a name, type, and program
      -- Optional entries are args, stopOnEntry, and cwd
      -- Example: cpp = { { name = "test", type = "lldb", request = "launch", program = "build/bin/foo" }, }
    },
  },
  adapters = {
    -- List of adapter tables here
    -- The name of each table becomes the 'type' used in the config
    -- Example: lldb = { name = 'lldb', type = 'executable', command = '/path/to/lldb-vscode' }
  },
}
return dap
]]
  f:write(dap_config)
  f:close()
end
vim.api.nvim_create_user_command("CreateLocalDAPConfig", create_starter_local_config, {})

-- Try loading a local "dap-config.lua" file
-- If no (absolute) path is give, then load from the current working directory
-- A template file can be created with the ':CreateLocalDAPConfig' command above
-- See the "default" configurations in this file for reference
local function load_local_config()
  local conf = vim.fn.getcwd() .. '/dap-config.lua'
  local f = io.open(conf)
  if f == nil then
    print("No dap-config.lua found in current working directory")
    return
  end
  f:close()

  -- Load the configs from the Lua file and append its configurations to
  -- the global DAP configurations specified here
  print("Loading dap-config file at: " .. conf)
  local dap_config = dofile(conf)
  if dap_config == nil then
    print("ERROR: file " .. conf .. " did not return a config table")
    return
  end

  -- Reset our DAP config table to the defaults
  local defaults = copy_dap_config(default_configs)
  dap.configurations = defaults.configurations
  dap.adapters = defaults.adapters

  -- Load debug configurations
  if dap_config.configurations ~= nil then
    -- Append the local configurations into the table
    for lang, configs in pairs(dap_config.configurations) do
      for _, c in ipairs(configs) do
        table.insert(dap.configurations[lang], c)
      end
    end
  else
    print("No configurations found in file")
  end

  -- Load adapter definitions
  if dap_config.adapters ~= nil then
    -- Append the local adapter configs into the table
    for name, config in pairs(dap_config.adapters) do
      dap.adapters[name] = config
    end
  else
    print("No adapters found in file")
  end
end
vim.api.nvim_create_user_command("LoadDAPConfig", load_local_config, {})

-- Get a Telescope list of all DAP configurations, including any which are
-- locally defined in a 'dap-config.lua' file
-- Filter the list by the current filetype
local function telescope_dap_configs()
  load_local_config()
  return telescope.extensions.dap.configurations({
    language_filter = function(lang)
      return lang == vim.bo.filetype
    end
  })
end

-- Helper Function: Prompt for user input for command arguments
local function prompt_for_args()
  return vim.split(vim.fn.input('Command Arguments: '), " ")
end

-- Helper Function: Prompt for binary to debug
-- The prompt defaults to the given path, e.g.: "vim.fn.getcwd() .. '/build/bin/'"
local function prompt_for_binary(default_path)
  return function()
    return vim.fn.input({
      prompt = 'Path to executable: ',
      default = vim.fn.getcwd() .. default_path,
      copmletion ='file',
    })
  end
end

-- Create a generic DAP config consisting of a name, adapter, and command
-- Prompts for user input if no args are given
local function create_config(name, adapter, command, args)
  args = args or prompt_for_args
  return {
    name = name,
    type = adapter,
    request = 'launch',
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    program = command,
    args = args,
  }
end

--------------------------------------------------------------------------
-- Setup Telescope as a binary picker for Conan-based repos
-- Show a picker for all executables at <cwd>/build/bin, then run an LLDB
-- DAP configuration on the chosen binary
-- The conanrun.sh script is sourced before running the command
--------------------------------------------------------------------------
-- Create an LLDB + Conan config
local function custom_conan_config(build_dir, exe)
  return create_config("Custom Conan exe runner", 'lldb', function()
      print('Sourcing ' .. build_dir .. '/generators/conanrun.sh')
      vim.fn.system('. ' .. build_dir .. '/generators/conanrun.sh')
      return exe
    end
  )
end

-- Start a DAP session using the output from the Telescope prompt buffer
local function start_conan_dap(prompt_bufnr)
	local cmd = tel_actions_state.get_selected_entry()
  tel_actions.close(prompt_bufnr)
  local build_dir = vim.fn.getcwd() .. '/build'
	dap.run(custom_conan_config(build_dir, cmd))
end

-- Launch a Telescope picker for binary files at <cwd>/build/bin
local function conan_picker()
  require("telescope.builtin").find_files({
    find_command = {'find', vim.fn.getcwd() .. '/build/bin/', '-type', 'f', '-executable'},
    attach_mappings = function(_, map)
      map("n", "<cr>", start_conan_dap)
      map("i", "<cr>", start_conan_dap)
      return true
    end,
  })
end
-- Map the above to the ':DebugConan' user command
vim.api.nvim_create_user_command('DebugConan', conan_picker, {})

-- Create a Zig + LLDB config
-- Start a DAP session using the output from the Telescope prompt buffer
local function start_zig_dap(prompt_bufnr)
	local cmd = tel_actions_state.get_selected_entry()[1]
  tel_actions.close(prompt_bufnr)
	dap.run(create_config("Custom Zig exe runner", 'lldb', cmd))
end

-- Launch a Telescope picker for binary files at <cwc>/build/bin
local function zig_picker()
  require("telescope.builtin").find_files({
    find_command = {'find', vim.fn.getcwd() .. '/zig-out/bin/', '-type', 'f', '-executable'},
    attach_mappings = function(_, map)
      map("n", "<cr>", start_zig_dap)
      map("i", "<cr>", start_zig_dap)
      return true
    end,
  })
end
-- Map the above to the ':DebugZig' user command
vim.api.nvim_create_user_command('DebugZig', zig_picker, {})

--------------------------------------------------------------------------
-- Keybindings & Customization
--------------------------------------------------------------------------

-- Configure our DAP-related keybindings
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, {})
vim.keymap.set('n', '<leader>dc', dap.continue, {})
vim.keymap.set('n', '<leader>dt', terminate_session, {})
vim.keymap.set('n', '<leader>n', dap.step_over, {})
vim.keymap.set('n', '<leader>si', dap.step_into, {})
vim.keymap.set('n', '<leader>so', dap.step_out, {})
vim.keymap.set('n', '<F5>', dap.continue, {})
vim.keymap.set('n', '<F10>', dap.step_over, {})
vim.keymap.set('n', '<F11>', dap.step_into, {})
vim.keymap.set('n', '<F12>', dap.step_out, {})
vim.keymap.set('n', '<leader>dl', dap.run_last, {})
vim.keymap.set('n', '<leader>td', telescope_dap_configs, {})

-- Change the breakpoint marker to a big red circle instead of a 'B'
vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})

--------------------------------------------------------------------------
-- Setup Adapters (Debuggers which support the Debug Adapter Protocol)
--------------------------------------------------------------------------

-- Setup LLDB
dap.adapters.lldb = {
  type = 'executable',
  command = lldb_bin,
  name = 'lldb',
}

-- Setup GDB
dap.adapters.gdb = {
  type = "executable",
  command = gdb_bin,
  args = { "-i", "dap" },
  name = 'gdb'
}

--------------------------------------------------------------------------
-- Configurations
--------------------------------------------------------------------------

-- Create a DAP Adapter config for GDB
-- Requires GDB >=14 for built-in DAP support
local function gdb_config(name, default_path)
  default_path = default_path or ''
  default_path = '/' .. default_path
  local bin_path = vim.fn.getcwd() .. default_path
  return {
    name = name,
    type = 'gdb',
    request = 'launch',
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    -- Take the executable and args via input prompt
    program = prompt_for_binary(bin_path),
    args = prompt_for_args,
  }
end

-- Create a DAP Adapter config for LLDB
local function lldb_config(name, default_path)
  default_path = default_path or ''
  default_path = '/' .. default_path
  return {
    name = name,
    type = 'lldb',
    request = 'launch',
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    -- Take the executable and args via input prompt
    program = prompt_for_binary(default_path),
    args = prompt_for_args,
  }
end

-- Create an LLDB + Conan config
local function conan_config(name, default_path)
  default_path = default_path or ''
  default_path = '/' .. default_path
  local bin_path = vim.fn.getcwd() .. default_path
  return {
    name = name,
    type = 'lldb',
    request = 'launch',
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    -- Take the executable via input prompt
    -- The prompt defaults to the the input default_path relative to the cwd
    -- This function first sources conanrun.sh to setup the environment
    program = function()
      print('Sourcing ' .. bin_path .. '/../generators/conanrun.sh')
      vim.fn.system('. ' .. bin_path .. '/../generators/conanrun.sh')
      return prompt_for_binary(bin_path)()
    end,
    -- Take the arguments list via input prompt
    args = prompt_for_args,
  }
end

-- Setup LLDB and GDB adapters for C++, C, and Zig
dap.configurations.cpp = {
  lldb_config("C++ exe + Args [CMake]", "build/bin/"),
  conan_config("Conan exe", "build/bin/"),
}
dap.configurations.c = {
  lldb_config("C exe + Args"),
  gdb_config("C exe + Args"),
  conan_config("Conan exe", "build/bin/")
}
dap.configurations.zig = {
  lldb_config("Zig exe + Args", "zig-out/bin/"),
  gdb_config("Zig exe + Args", "zig-out/bin/")
}

-- A "mock" debug adapter that "debugs" Markdown files.
-- Could be useful for testing configs if it ever works.
dap.adapters.markdown = {
  type = "executable",
  name = "markdown",
  command = node_bin,
  args = {"./out/debugAdapter.js"},
  cwd = vim.env.HOME .. "/.local/share/nvim/mason/packages/mockdebug"
}
dap.adapters.mock = dap.adapters.markdown

dap.configurations.markdown = {
  {
    type = "markdown",
    request = "launch",
    name = "mock test",
    program = function()
      return vim.fn.input({
        prompt = 'Path to Markdown file: ',
        default = vim.fn.getcwd() .. '/',
        completion = 'file',
      })
    end,
    stopOnEntry = true,
    debugServer = 4711
  },
}

-- Create a deep copy of the configurations defined above
-- This allows us to reset the dap config tables to these defaults later
default_configs = copy_dap_config(dap)
