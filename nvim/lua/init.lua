-- Enable full color and highlighting support
vim.opt.termguicolors = true

-- Mason
require("mason").setup()

-- Nvim-Tree
require("nvim_tree_setup")

-- All custom Autocommands
require('autocmds')

-- Code Completion
require('cmp_setup')

-- Lualine (statusline)
require('lualine_setup')

-- Telescope
require('telescope_setup')

-- TreeSitter
require('ts_setup')

-- Misc. Style Config
require('style')

-- Language Setup (LSPs)
require('lsp_setup')

-- Gitsigns: Git status tracking symbols
-- require('gitsigns_setup.lua')
