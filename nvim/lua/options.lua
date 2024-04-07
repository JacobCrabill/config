-- Enable full color and highlighting support
vim.opt.termguicolors = true

vim.opt.encoding = 'utf-8'

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.cursorline = true
vim.opt.cursorcolumn = false
vim.opt.mouse = 'a'
vim.opt.relativenumber = true
vim.opt.updatetime = 80
vim.opt.wrap = false

-- Use case insensitive search, except when using capital letters
vim.opt.ignorecase = true
vim.opt.smartcase  = true

vim.opt.expandtab   = true -- Convert tabs to spaces
vim.opt.tabstop     = 2    -- Size of existing tab characters
vim.opt.softtabstop = 2    -- Size of a new tab while editing
vim.opt.shiftwidth  = 2    -- when indenting with '>', use 2 spaces width

-- Whitespace characters to make visibile when in 'vim.opt.list'
vim.opt.listchars = { tab = '>-' }
