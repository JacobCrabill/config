-- Set <leader> to <space>
vim.g.mapleader = " "

-- Turn off macros
vim.keymap.set('n', 'q', '<Nop>', {})

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
-- Note that since Lua caches require()'d modules, we have to clear them
-- in order to reload our config
local function sourceConfig()
  print('~~ Reloading Neovim config ~~')
  package.loaded['options'] = false
  package.loaded['maps'] = false
  package.loaded['dap_config'] = false
  package.loaded['autocmds'] = false
  package.loaded['style'] = false
  package.loaded['cmp_setup'] = false
  package.loaded['lualine_setup'] = false
  package.loaded['lsp_setup'] = false
  package.loaded['ts_setup'] = false
  package.loaded['misc'] = false
  vim.cmd('source ' .. nvimrc .. '/init.vim')
  print('~~ Neovim config reloaded ~~')
end
vim.keymap.set('n', '<A-0>', sourceConfig, {})

-- For copy/paste to/from system clipboard (register '+')
vim.keymap.set('n', '<leader>y', [["+y]], { noremap = true })
vim.keymap.set('v', '<C-c>', [["+y]], { noremap = true })
vim.keymap.set('v', '<C-x>', [["+c<ESC>]], { noremap = true })
vim.keymap.set('v', '<C-v>', [[c<ESC>"+p]], { noremap = true })
vim.keymap.set('i', '<C-v>', [[<C-r><C-o>+]], { noremap = true })
vim.keymap.set('t', '<C-v>', [[<ESC>"+pi]], { noremap = true })

-- Visual paste: replace selection
vim.keymap.set('v', 'p', [["_dP]], { noremap = true })

-- Exit insert mode with my right hand w/o leaving home row
vim.keymap.set('i', ',,', '<ESC>', {})
vim.keymap.set('n', ',,', ':<c-u><C-r>=b:VM_Selection.Vars.noh<CR>call vm#reset()<cr>', { noremap=true, silent=true }) -- not perfect; not sure what's missing

-- Map <C-L> (redraw screen) to also turn off search highlights
-- until the next search
vim.keymap.set('n', '<C-L>', [[:nohl<CR><C-L>]], { noremap = true })

-- Glow (side-pane Markdown rendering)
vim.keymap.set('n', '<A-g>', [[:Glow<CR>]], {})

-- Keep window, close buffer
vim.keymap.set('n', '<C-d>', [[:Kwbd<CR>]], {})

-- Page Up, Page Down
vim.keymap.set('n', '<C-j>', '<PageDown>', {})
vim.keymap.set('n', '<C-k>', '<PageUp>', {})

-- Format JSON files
vim.keymap.set('n', '<leader>jq', [[:%!jq<CR>]], {})

-- Jump between windows with fewer key presses
vim.keymap.set('n', '<A-1>', '<C-w>h', {})
vim.keymap.set('n', '<A-2>', '<C-w>l', {})

-- Telescope -------------------------------------------------------------------
vim.keymap.set('n', '<C-g>', ':Telescope live_grep<cr>', {})
vim.keymap.set('n', '<C-p>', ':Telescope find_files<cr>', {})
vim.keymap.set('n', '<C-h>', ':Telescope grep_string<cr>', {})
vim.keymap.set('n', '<C-f>', ':Telescope resume<cr>', {}) -- Open last search
--------------------------------------------------------------------------------

-- BarBar ----------------------------------------------------------------------
-- Move to previous/next tab
vim.keymap.set('n', '<A-,>',   [[<Cmd>BufferPrevious<CR>]],     { silent = true })
vim.keymap.set('n', '<A-.>',   [[<Cmd>BufferNext<CR>]],         { silent = true })
-- Re-order tab to previous/next
vim.keymap.set('n', '<A-<>',   [[<Cmd>BufferMovePrevious<CR>]], { silent = true })
vim.keymap.set('n', '<A->>',   [[<Cmd>BufferMoveNext<CR>]],     { silent = true })
vim.keymap.set('n', '<A-S-,>', [[<Cmd>BufferMovePrevious<CR>]], { silent = true })
vim.keymap.set('n', '<A-S-.>', [[<Cmd>BufferMoveNext<CR>]],     { silent = true })
--------------------------------------------------------------------------------

-- Terminal mode: Allow ESC to exit insert mode
vim.keymap.set('t', '<ESC>', [[<C-\><C-n>]], { noremap = true })

-- Clear terminal (nvim terminal equivalent to 'reset' in normal terminal)
local scroll_value = 5000
function ClearTerm()
  vim.opt_local.scrollback = 1

  vim.api.nvim_command("startinsert")
  vim.api.nvim_feedkeys("reset", 't', false)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<cr>', true, false, true), 't', true)

  vim.opt_local.scrollback = scroll_value
end
vim.api.nvim_set_keymap('t', '<C-l>', [[<C-\><C-N>:lua ClearTerm()<CR>]], { noremap = true })

-- FloatTerm -------------------------------------------------------------------
vim.g.floaterm_width = 0.6
vim.g.floaterm_height = 0.75
vim.keymap.set('n', '<C-t>',      [[:FloatermToggle<cr>]], { noremap = true })
vim.keymap.set('n', '<A-t>',      [[:FloatermNext<cr>]],   { noremap = true })
vim.keymap.set('n', '<A-T>',      [[:FloatermPrev<cr>]],   { noremap = true })
vim.keymap.set('n', '<C-x><C-t>', [[:FloatermNew<cr>]],    { noremap = true })
vim.keymap.set('t', '<C-t>',      [[<C-\><C-n>:FloatermToggle<cr>]], { noremap = true })
vim.keymap.set('t', '<A-t>',      [[<C-\><C-n>:FloatermNext<cr>]],   { noremap = true })
vim.keymap.set('t', '<A-T>',      [[<C-\><C-n>:FloatermPrev<cr>]],   { noremap = true })
vim.keymap.set('t', '<C-x><C-t>', [[<C-\><C-n>:FloatermNew<cr>]],    { noremap = true })
--------------------------------------------------------------------------------

-- Kitty Window Navigation -----------------------------------------------------
-- Extends Vim window navigation seamlessly with the Kitty terminal ------------
vim.g.kitty_navigator_no_mappings = 1
vim.keymap.set('n', '<C-w>h', [[:KittyNavigateLeft<cr>]],  { silent = true })
vim.keymap.set('n', '<C-w>j', [[:KittyNavigateDown<cr>]],  { silent = true })
vim.keymap.set('n', '<C-w>k', [[:KittyNavigateUp<cr>]],    { silent = true })
vim.keymap.set('n', '<C-w>l', [[:KittyNavigateRight<cr>]], { silent = true })
--------------------------------------------------------------------------------
