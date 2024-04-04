-- Configure our Debug Adapter Protocol settings
local dap = require("dap")
local dapui = require("dapui")
local tel_actions_state = require("telescope.actions.state")
local tel_actions = require("telescope.actions")

-- Set the paths to the available debuggers
local lldb_bin = '/home/jacob/.local/bin/lldb-vscode'
local gdb_bin = '/home/jacob/.local/bin/gdb'
local node_bin = '/home/jacob/.nvm/versions/node/v20.11.1/bin/node'

require('nvim-dap-virtual-text').setup()
dapui.setup()

-- Enable Telescope as a configuration picker
local telescope = require('telescope')
telescope.load_extension('dap')

-- Automatically open/close the DAP UI on session start/end
dap.listeners.before.attach.dapui_config = dapui.open
dap.listeners.before.launch.dapui_config = dapui.open
dap.listeners.before.event_terminated.dapui_config = dapui.close
dap.listeners.before.event_exited.dapui_config = dapui.close

-- Terminate the debug session and close DAP UI
local function terminate_session()
  dap.terminate()
  dapui.close()
end

-- Get a Telescope list of all DAP configurations
-- Filter the list by the current filetype
local function telescope_dap_configs()
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
  local build_dir = vim.fn.getcwd() .. '/build' -- TODO: Can I get this from 'cmd' somehow?
	dap.run(custom_conan_config(build_dir, cmd))
end

-- Launch a Telescope picker for binary files at <cwc>/build/bin
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

-- Configure our DAP-related keybindings
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, {})
vim.keymap.set('n', '<leader>dc', dap.continue, {})
vim.keymap.set('n', '<leader>dt', terminate_session, {})
vim.keymap.set('n', '<leader>n', dap.step_over, {})
vim.keymap.set('n', '<leader>si', dap.step_into, {})
vim.keymap.set('n', '<leader>so', dap.step_out, {})
vim.keymap.set('n', '<F10>', dap.step_over, {})
vim.keymap.set('n', '<F11>', dap.step_into, {})
vim.keymap.set('n', '<F12>', dap.step_out, {})
vim.keymap.set('n', '<leader>td', telescope_dap_configs, {})

-- Setup LLDB
dap.adapters.lldb = {
  type = 'executable',
  command = lldb_bin,
  name = 'lldb'
}

-- Setup GDB
dap.adapters.gdb = {
  type = "executable",
  command = gdb_bin,
  args = { "-i", "dap" },
  name = 'gdb'
}

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
    -- Take the executable via input prompt
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. default_path, 'file')
    end,
    -- Take the arguments list via input prompt
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
    -- Take the executable via input prompt
    -- The prompt defaults to the the input default_path relative to the cwd
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. default_path, 'file')
    end,
    -- Take the arguments list via input prompt
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
      return vim.fn.input('Path to executable: ', bin_path, 'file')
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
-- Can be useful for testing configs.
dap.adapters.markdown = {
  type = "executable",
  name = "mockdebug",
  command = node_bin,
  args = {"./out/debugAdapter.js"},
  cwd = vim.env.HOME .. "/.local/share/nvim/mason/packages/mockdebug"
}
dap.adapters.mock = dap.adapters.markdown

dap.configurations.markdown = {
  {
    type = "mock",
    request = "launch",
    name = "mock test",
    program = function()
      return vim.fn.input('Path to Markdown file: ', vim.fn.getcwd() .. '/', 'file')
    end,
    stopOnEntry = true,
    debugServer = 4711
  },
}

