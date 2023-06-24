" ============================================================================
" NeoVim Config File
" ---------------------------------------------------------------------------=
" Location: ~/.config/nvim/init.vim
" Requires: NeoVim v0.7 - e.g. [v0.7.2](https://github.com/neovim/neovim/releases/tag/v0.7.2)
"
" First-Time Usage:
" 1. Install a [Nerd Font](https://github.com/ryanoasis/nerd-fonts#option-3-install-script)
" 2. Install python3 support: 'pip3 install neovim pynvim'
" 3. Install [vim-plug](https://github.com/junegunn/vim-plug)
" 4. Call: `:PlugInstall`
" 5. Profit
" ============================================================================
" Source our plugin include file
:runtime plug.vim

" Setup Autocommands =========================================================
augroup vimrc
  " Remove all vimrc autocommands
  autocmd!

  " Call Clang-Format
  autocmd BufWritePre *.h,*.hpp,*.c,*.cpp,*.vert,*.frag :ClangFormat

  " Call markdown-format
  " autocmd BufWritePre *.md | silent write | silent :execute '! mdformat --wrap 100 --end-of-line keep %' | edit! %

  autocmd BufWritePre CMakeLists.txt silent write | silent :execute '! cmake-format --in-place %' | edit! %
  " Automatically strip trailing whitespace in other file types
  " autocmd BufWritePre CMakeLists.txt :StripWhitespace

  " Reset cursor to last location when opening file (marker '"')
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

  " Set the EOSLang filetype to C (for syntax highlighting purposes)
  autocmd BufNewFile,BufRead *.eos   set syntax=cpp
augroup END
" ============================================================================

set completeopt=menu,menuone,noselect
set cursorline
set cursorcolumn
set mouse=a
set number relativenumber
set updatetime=100

set encoding=utf-8
scriptencoding utf-8 " Enable utf-8 in the rest of this script

" Allow >256 colors
set termguicolors

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

set expandtab     " Convert tabs to spaces
set tabstop=2     " Size of existing tab characters
set softtabstop=2 " Size of a new tab while editing
set shiftwidth=2  " when indenting with '>', use 2 spaces width

" Whitespace characters to make visibile when in 'set list'
set listchars=tab:>-

" Turn off line wrapping
set nowrap

" Remap <leader> to <space>
let mapleader=" "

let g:rainbow_active = 1 " Set to 0 if you want to enable it later via :RainbowToggle

let python_highlight_all = 1

let g:jedi#auto_initialization = 1

let g:indent_guides_auto_colors = 0
let g:indentguides_spacechar = '┆'
let g:indentguides_tabchar = '|'

let g:clang_format#detect_style_file=1
let g:clang_format#enable_fallback_style=0

" TURN OFF MACROS
map q <Nop>

" For copy/paste to/from system clipboard (register '+')
vmap <C-c> "+y
vmap <C-x> "+c<ESC>
vmap <C-v> c<ESC>"+p
imap <C-v> <C-r><C-o>+
tmap <C-v> <ESC>"+pi
noremap <Leader>y "+y

" Visual paste: replace selection
vnoremap p "_dP

" Jump between windows
map <A-1> <C-w>h
map <A-2> <C-w>l

" Easy config edit
nnoremap <A-)> :edit ~/.config/nvim/init.vim<CR>
nnoremap <A-S-0> :edit ~/.config/nvim/init.vim<CR>
" Easy re-source
noremap <A-0> :source ~/.config/nvim/init.vim<CR>

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

" Glow (side-pane Markdown rendering)
nnoremap <A-g> :Glow<CR>

" Shortcut for :Kwbd (Keep window, close buffer)
nnoremap <C-d> :Kwbd<CR>

" Page Up, Page Down
nnoremap <C-j> <PageDown>
nnoremap <C-k> <PageUp>

" Telescope: ==================================================================
nnoremap <C-G> :Telescope live_grep<cr>
nnoremap <C-P> :Telescope find_files<cr>
nnoremap <C-H> :Telescope grep_string<cr>
" Open last search result
nnoremap <C-F> :Telescope resume<cr>
" ============================================================================

" NvimTree: ==================================================================
" Map file browser pane open/close
nnoremap <silent> <C-o> :NvimTreeToggle %<CR>
" ============================================================================

" BarBar: ====================================================================
" Move to previous/next tab
nnoremap <silent>    <A-,> <Cmd>BufferPrevious<CR>
nnoremap <silent>    <A-.> <Cmd>BufferNext<CR>
" Re-order tab to previous/next
nnoremap <silent>    <A-<> <Cmd>BufferMovePrevious<CR>
nnoremap <silent>    <A->> <Cmd>BufferMoveNext<CR>
nnoremap <silent>    <A-S-,> <Cmd>BufferMovePrevious<CR>
nnoremap <silent>    <A-S-.> <Cmd>BufferMoveNext<CR>
" ============================================================================

" Kitty Window Navigation ====================================================
" Extends Vim window navigation seamlessly with the Kitty terminal
let g:kitty_navigator_no_mappings = 1

nnoremap <silent> <C-W>h :KittyNavigateLeft<cr>
nnoremap <silent> <C-W>j :KittyNavigateDown<cr>
nnoremap <silent> <C-W>k :KittyNavigateUp<cr>
nnoremap <silent> <C-W>l :KittyNavigateRight<cr>
" ============================================================================

" Source the rest of our setup files
:runtime maps.vim
:runtime pretty.vim
:runtime term_setup.vim
:runtime lua/vim_setup.lua
