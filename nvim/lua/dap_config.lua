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

vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, {})
vim.keymap.set('n', '<leader>dc', dap.continue, {})
vim.keymap.set('n', '<leader>n', dap.step_over, {})
vim.keymap.set('n', '<leader>si', dap.step_into, {})
vim.keymap.set('n', '<leader>so', dap.step_into, {})
vim.keymap.set('n', '<F10>', dap.step_over, {})
vim.keymap.set('n', '<F11>', dap.step_into, {})
vim.keymap.set('n', '<F12>', dap.step_out, {})
vim.keymap.set('n', '<leader>td', telescope.extensions.dap.configurations, {})

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

-- Setup LLDB adapters for C++, C, and Zig
dap.configurations.cpp = { lldb_config("C++ exe + Args [CMake]", "build/bin/") }
dap.configurations.c = { lldb_config("C exe + Args") }
dap.configurations.zig = { lldb_config("Zig exe + Args", "zig-out/bin/") }

-- Setup GDB adapters for C++, C, and Zig
dap.configurations.cpp = { gdb_config("C++ exe + Args [CMake]", "build/bin/") }
dap.configurations.c = { gdb_config("C exe + Args") }
dap.configurations.zig = { gdb_config("Zig exe + Args", "zig-out/bin/") }

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
      program = "/home/jacob/Codes/slidey/README.md",
      stopOnEntry = true,
      debugServer = 4711
   }
 }

