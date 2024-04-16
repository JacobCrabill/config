-- Enable full color and highlighting support
vim.opt.termguicolors = true

vim.opt.encoding = 'utf-8'

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.cursorline = true
vim.opt.cursorcolumn = false
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.updatetime = 100
vim.opt.wrap = false
vim.opt.showmode = false

-- Use case insensitive search, except when using capital letters
vim.opt.ignorecase = true
vim.opt.smartcase  = true

vim.opt.expandtab   = true -- Convert tabs to spaces
vim.opt.tabstop     = 2    -- Size of existing tab characters
vim.opt.softtabstop = 2    -- Size of a new tab while editing
vim.opt.shiftwidth  = 2    -- when indenting with '>', use 2 spaces width

-- Whitespace characters to make visibile
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 10

-- Fully share clipboards between vim and system
-- vim.opt.clipboard = 'unnamedplus'

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 250
