-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

vim.g.have_nerd_font = true

require('lazy').setup({
  'SmiteshP/nvim-navic',
  'sindrets/diffview.nvim',
  'voldikss/vim-floaterm',  -- Floating terminal buffers
  'mg979/vim-visual-multi', -- Multiple cursors

  { -- Telescope: Quickly search through files, integrate with LSP, etc.
      'nvim-telescope/telescope.nvim',
      event = 'VimEnter',
      branch = '0.1.x',
      dependencies = {
        'nvim-lua/plenary.nvim',
        { -- If encountering errors, see telescope-fzf-native README for installation instructions
          'nvim-telescope/telescope-fzf-native.nvim',

          -- `build` is used to run some command when the plugin is installed/updated.
          -- This is only run then, not every time Neovim starts up.
          build = 'make',

          -- `cond` is a condition used to determine whether this plugin should be
          -- installed and loaded.
          cond = function()
            return vim.fn.executable 'make' == 1
          end,
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },

        -- Pretty icons; requires a Nerd Font.
        { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      },
  },


  -- ==== Code Completion ==========================================
  'nvim-lua/completion-nvim',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/nvim-cmp',
  -- For vsnip users. Do I use this?? idk
  'hrsh7th/vim-vsnip',
  'hrsh7th/cmp-vsnip',

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = { 'nvim-treesitter/playground' },
  },
  'tpope/vim-fugitive', -- Nice Git integration
  -- 'tpope/vim-commentary'

  -- NvimTree - Excellet, configurable file browswer written in Lua
  'nvim-tree/nvim-tree.lua',

  -- Integration with Kitty for window navigation
  {
    'knubie/vim-kitty-navigator',
    build = 'cp ./*.py ~/.config/kitty/',
  },

  -- ==== Style Customization ======================================
  -- Color Schemes
  -- 'sainnhe/forest-night'
  'EdenEast/nightfox.nvim',
  'navarasu/onedark.nvim',
  'marko-cerovac/material.nvim',
  'catppuccin/nvim', -- { 'as': 'catppuccin' },
  'drewtempelmeyer/palenight.vim',
  'folke/tokyonight.nvim',
  'rmehri01/onenord.nvim',

  -- Fonts, icons, statusbars
  'nvim-lualine/lualine.nvim', -- Fancy status bar. Like Vim-Airline, but better
  'kyazdani42/nvim-web-devicons', -- Requires a NerdFont to be in use

  -- Keep Window, Close Buffer
  'rgarver/Kwbd.vim',

  -- ==== Debugging Support ========================================
  -- 'puremourning/vimspector'
  'mfussenegger/nvim-dap',
  'rcarriga/nvim-dap-ui',
  'nvim-neotest/nvim-nio', -- nvim-dap-ui says it's needed
  'nvim-telescope/telescope-dap.nvim',
  -- 'theHamsta/nvim-dap-virtual-text', -- didn't really like it; slows things down a lot

  -- Open-Windows Tab bar
  'romgrk/barbar.nvim',

  -- Highlight trailing whitespace
  'ntpeters/vim-better-whitespace',

  -- Escape ANSI sequences and colorize output
  'powerman/vim-plugin-AnsiEsc',

  -- ==== Language Support ========================================
  -- Language Servers Provider and other language suppport plugins
  'ziglang/zig.vim', -- Zig language support
  'simrat39/rust-tools.nvim', -- Rust language support
  'neovim/nvim-lspconfig',
  'rhysd/vim-clang-format',
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'aklt/plantuml-syntax',
  'jjo/vim-cue',
  'fladson/vim-kitty', -- Kitty config syntax highlighting
  'folke/neodev.nvim' ,-- Lua & NeoVim API LSP support

  -- ==== Misc Tools ==============================================
  -- Render code to a PNG image
  -- Prerequisites: See https://crates.io/crates/silicon
  --   cargo install silicon
  'segeljakt/vim-silicon',

  -- In-buffer Markdown rendering
  'jacobcrabill/glow.nvim',
})

-- Add our Lua folder to the runtime path, and source its init.lua
local nvimrc = vim.fn.stdpath('config')
vim.opt.rtp:append(nvimrc .. 'lua')
require('init')
