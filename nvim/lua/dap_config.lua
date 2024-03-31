-- Configure our Debug Adapter Protocol settings
local dap = require("dap")
local dapui = require("dapui")

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

-- Get a Telescope list of all DAP configurations
-- Filter the list by the current filetype
local function telescope_dap_configs()
  return telescope.extensions.dap.configurations({
    language_filter = function(lang)
      return lang == vim.bo.filetype
    end
  })
end

vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, {})
vim.keymap.set('n', '<leader>dc', dap.continue, {})
vim.keymap.set('n', '<leader>dt', dap.terminate, {})
vim.keymap.set('n', '<leader>n', dap.step_over, {})
vim.keymap.set('n', '<leader>si', dap.step_into, {})
vim.keymap.set('n', '<leader>so', dap.step_into, {})
vim.keymap.set('n', '<F10>', dap.step_over, {})
vim.keymap.set('n', '<F11>', dap.step_into, {})
vim.keymap.set('n', '<F12>', dap.step_out, {})
vim.keymap.set('n', '<leader>td', telescope_dap_configs, {})

dap.adapters.lldb = {
  type = 'executable',
  command = '/home/jacob/.local/apps/clang-llvm-16/bin/lldb-vscode', -- adjust as needed, must be absolute path
  name = 'lldb'
}

dap.adapters.gdb = {
  type = "executable",
  command = "/home/jacob/.local/bin/gdb",
  args = { "-i", "dap" },
  name = 'gdb'
}

-- Create a DAP Adapter config for GDB
-- Requires GDB >=14 for built-in DAP support
local function gdb_config(name, default_path)
  default_path = default_path or ''
  default_path = '/' .. default_path
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
    args = function()
      local t = {}
      for arg in string.gmatch(vim.fn.input('Cmd Arguments: '), "%S+") do
        table.insert(t, arg)
      end
      return t
    end,
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
    args = function()
      local t = {}
      for arg in string.gmatch(vim.fn.input('Cmd Arguments: '), "%S+") do
        table.insert(t, arg)
      end
      return t
    end,
  }
end

-- Create an LLDB + Conan config
local function conan_config(name, default_path)
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
    -- This function first sources conanrun.sh to setup the environment
    program = function()
      vim.fn.system('. ' .. '${workspaceFolder}' .. '/build/generators/conanrun.sh')
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. default_path, 'file')
    end,
    -- Take the arguments list via input prompt
    args = function()
      local t = {}
      for arg in string.gmatch(vim.fn.input('Cmd Arguments: '), "%S+") do
        table.insert(t, arg)
      end
      return t
    end,
  }
end

-- Setup LLDB and GDB adapters for C++, C, and Zig
dap.configurations.cpp = {
  lldb_config("C++ exe + Args [CMake]", "build/bin/"),
  gdb_config("C++ exe + Args [CMake]", "build/bin/"),
  conan_config("Conan exe", "build/bin/")
}
dap.configurations.c = {
  lldb_config("C exe + Args"),
  gdb_config("C exe + Args")
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
  command = "/home/jacob/.nvm/versions/node/v20.11.1/bin/node",
  args = {"./out/debugAdapter.js"},
  cwd = "/home/jacob/.local/share/nvim/mason/packages/mockdebug"
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

