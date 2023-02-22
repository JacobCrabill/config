call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')
Plug 'SmiteshP/nvim-navic'
Plug 'aaronma37/ts-word-wrapper.nvim'
Plug 's1n7ax/neovim-lua-plugin-boilerplate'
Plug 'sindrets/diffview.nvim'
Plug 'voldikss/vim-floaterm'  " Floating terminal buffers
Plug 'tpope/vim-repeat'
" Plug 'ggandor/lightspeed.nvim'
Plug 'nvim-lua/plenary.nvim'

Plug 'mg979/vim-visual-multi' " Multiple cursors
Plug 'terryma/vim-multiple-cursors'
Plug 'xiyaowong/nvim-cursorword'

" telescope - Quickly search through files
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" ==== Code Completion ==========================================
Plug 'nvim-lua/completion-nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
" For vsnip users.
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-vsnip'

Plug 'nvim-treesitter/playground'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'tpope/vim-fugitive' " Nice Git integration
" Plug 'Yggdroot/LeaderF'
Plug 'tpope/vim-commentary'

" NerdTree - Quickly and easily browse directories and files
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" ==== Style Customization ======================================
" Color Schemes
Plug 'sainnhe/forest-night'
Plug 'EdenEast/nightfox.nvim'
Plug 'navarasu/onedark.nvim'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'karoliskoncevicius/sacredforest-vim'
Plug 'srcery-colors/srcery-vim'
Plug 'folke/tokyonight.nvim'
Plug 'tomasiser/vim-code-dark'
Plug 'rhysd/vim-color-spring-night'

" Fonts, icons, statusbars
Plug 'nvim-lualine/lualine.nvim' " Fancy status bar. Like Vim-Airline, but better
" If you want to have icons in your statusline choose one of these
" NOTE: Requires Nerd Fonts to be installed and in use
Plug 'kyazdani42/nvim-web-devicons'

" Keep Window, Close Buffer
Plug 'rgarver/Kwbd.vim'

" Debugging support
Plug 'puremourning/vimspector'

" In-buffer Markdown rendering
Plug 'jacobcrabill/glow.nvim'

" Open-Windows Tab bar
Plug 'romgrk/barbar.nvim'

" Highlight trailing whitespace
Plug 'ntpeters/vim-better-whitespace'

" Escape ANSI sequences and colorize output
Plug 'powerman/vim-plugin-AnsiEsc'

" ==== Language Support ========================================
" Language Servers Provider and other language suppport plugins
Plug 'ziglang/zig.vim' " Zig language support
Plug 'simrat39/rust-tools.nvim' " Rust language support
Plug 'neovim/nvim-lspconfig'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'rhysd/vim-clang-format'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

" Render code to a PNG image
" Prerequisites: See https://crates.io/crates/silicon
"   cargo install silicon
Plug 'segeljakt/vim-silicon'
call plug#end() " =============================================================
