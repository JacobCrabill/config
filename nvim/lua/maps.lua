-- The standard NeoVim config path
local nvimrc = vim.fn.stdpath('config')

-- Jump to NeoVim config folder in Nvim-Tree
local function openConfig()
  local nvim_tree = require('nvim-tree.api')
  nvim_tree.tree.close()
  nvim_tree.tree.open({ path = nvimrc })
end
vim.keymap.set('n', '<A-S-0>', openConfig, {})

-- Re-source the NeoVim config
local function sourceConfig()
  vim.cmd('source ' .. nvimrc .. '/init.vim')
end
vim.keymap.set('n', '<A-0>', sourceConfig, {})
