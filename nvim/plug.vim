call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')
Plug 'SmiteshP/nvim-navic'
Plug 'lewis6991/gitsigns.nvim'
Plug 'aaronma37/ts-word-wrapper.nvim'
Plug 's1n7ax/neovim-lua-plugin-boilerplate'
Plug 'sindrets/diffview.nvim'
Plug 'nvim-treesitter/playground'
Plug 'xiyaowong/nvim-cursorword'
Plug 'voldikss/vim-floaterm'
Plug 'tpope/vim-repeat'
Plug 'ggandor/lightspeed.nvim'
Plug 'nvim-lualine/lualine.nvim'
" If you want to have icons in your statusline choose one of these
" NOTE: Requires Nerd Fonts to be installed and in use
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'EdenEast/nightfox.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" For vsnip users.
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'tpope/vim-fugitive'
" Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'tomasiser/vim-code-dark'
Plug 'joshdick/onedark.vim'
Plug 'thaerkh/vim-workspace'
Plug 'terryma/vim-multiple-cursors'
Plug 'srcery-colors/srcery-vim'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'Yggdroot/LeaderF'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'rhysd/vim-clang-format'
Plug 'tpope/vim-commentary'

" Color Schemes and Style Config
Plug 'sainnhe/forest-night'
Plug 'rhysd/vim-color-spring-night'
Plug 'karoliskoncevicius/sacredforest-vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'tomasiser/vim-code-dark'
Plug 'folke/tokyonight.nvim'
Plug 'drewtempelmeyer/palenight.vim'

" Keep Window, Close Buffer
Plug 'rgarver/Kwbd.vim'

" Debugging support
Plug 'puremourning/vimspector'

" In-buffer Markdown rendering
" Plug 'ellisonleao/glow.nvim'
Plug 'jacobcrabill/glow.nvim'

" Open-Windows Tab bar
Plug 'romgrk/barbar.nvim'

" Highlight trailing whitespace
Plug 'ntpeters/vim-better-whitespace'

" Better built-in terminal
Plug 'https://github.com/kassio/neoterm'

" ANSI escape character handling (doesn't work?)
Plug 'powerman/vim-plugin-AnsiEsc'

" Render a code snippet to an image in your clipboard
Plug 'krivahtoo/silicon.nvim', { 'do': './install.sh' }

" Additional language-support package manager, Mason
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

" Rust languange support
Plug 'simrat39/rust-tools.nvim'

call plug#end() " ================================================================================
