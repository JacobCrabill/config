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
augroup END
" ============================================================================

set completeopt=menu,menuone,noselect

let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
let python_highlight_all = 1
set relativenumber
let g:jedi#auto_initialization = 1
set cursorline
set cursorcolumn
set mouse=a

" Allow >256 colors
set termguicolors

set encoding=utf-8
scriptencoding utf-8

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

let g:indent_guides_auto_colors = 0

set updatetime=100

" NerdTree: Map file browser pane open/close
nnoremap <silent> <C-o> :NERDTreeToggle %<CR>
vnoremap p "_dP

let g:indentguides_spacechar = '┆'
let g:indentguides_tabchar = '|'

" barbar: Move to previous/next tab
nnoremap <silent>    <A-,> <Cmd>BufferPrevious<CR>
nnoremap <silent>    <A-.> <Cmd>BufferNext<CR>
" barbar: Re-order tab to previous/next
nnoremap <silent>    <A-<> <Cmd>BufferMovePrevious<CR>
nnoremap <silent>    <A->> <Cmd>BufferMoveNext<CR>

set expandtab
" show existing tab with 2 spaces width
set tabstop=2
set softtabstop=2
" when indenting with '>', use 2 spaces width
set shiftwidth=2
let &t_TI = ""
let &t_TE = ""
set listchars=tab:>-

let g:clang_format#detect_style_file=1
let g:clang_format#enable_fallback_style=0

" TURN OFF MACROS
map q <Nop>

" For copy paste
" vmap <C-c> "+yi
" vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <C-r><C-o>+
tmap <C-v> <ESC>"+pi

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

" Glow (side-pane Markdown rendering)
nnoremap <A-g> :Glow<CR>

" Telecope Config ============================================================
nnoremap <C-G> :Telescope live_grep<cr>
nnoremap <C-P> :Telescope find_files<cr>
" ============================================================================

" Quick commands - goto EdgeAI, goto Home
map EE :cd ~/Codes/EdgeAI<CR>
map EH :cd ~/<CR>

" Jump between windows
map <A-1> <C-w>h
map <A-2> <C-w>l

" Easy config edit
nnoremap <A-)> :edit ~/.config/nvim/init.vim<CR>
" Easy re-source
noremap <A-0> :source ~/.config/nvim/init.vim<CR>

" Shortcut for :Kwbd (Keep window, close buffer)
nnoremap <C-d> :Kwbd<CR>

if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

:runtime pretty.vim
:runtime term_setup.vim
:runtime vim_setup.lua
