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
set number
let g:jedi#auto_initialization = 1
set cursorline
set cursorcolumn

" Allow >256 colors
set termguicolors

set encoding=utf-8
scriptencoding utf-8

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

let g:indent_guides_auto_colors = 0
" autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=3
" autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4

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

"TURN OFF MACROS
map q <Nop>
"terminal scroll off
":set scrolloff=5
"
"
" For copy paste
" vmap <C-c> "+yi
" vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <C-r><C-o>+
tmap <C-v> <ESC>"+pi

let g:Lf_HideHelp = 1
let g:Lf_UseCache = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_IgnoreCurrentBufferName = 1
" popup mode
let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2", 'font': "DejaVu Sans Mono for Powerline" }
let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }
let g:Lf_CommandMap = {'<C-K>': ['<Up>'], '<C-J>': ['<Down>']}

let g:Lf_ShortcutF = "<leader>ff"
noremap <leader>fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
noremap <leader>fm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
noremap <leader>ft :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
noremap <leader>fl :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>


noremap <C-B> :<C-U><C-R>=printf("Leaderf! rg --current-buffer -e %s ", expand("<cword>"))<CR>
noremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR>
" search visually selected text literally
xnoremap gf :<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR>
noremap go :<C-U>Leaderf! rg --recall<CR>

" should use `Leaderf gtags --update` first
let g:Lf_GtagsAutoGenerate = 0
let g:Lf_Gtagslabel = 'native-pygments'
let g:neovide_cursor_vfx_mode = "pixiedust"
let g:neovide_cursor_antialiasing=v:true

" noremap <leader>fr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
" noremap <leader>fd :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
" noremap <leader>fo :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
" noremap <leader>fn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
" noremap <leader>fp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>
" nnoremap <silent> <C-H> :Leaderf mru<CR>
" " Gitsigns
" nnoremap <silent> <C-L> :Gitsigns diffthis<CR>
" nnoremap <silent> <C-J> :Gitsigns next_hunk<CR>
" nnoremap <silent> <C-K> :Gitsigns prev_hunk<CR>

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

" Glow (Markdown rendering) --> Alt-p
" execute "set <M-p>=\ep"
nnoremap <A-g> :Glow<CR>

" Telecope Config ============================================================
" nnoremap <C-G> :lua require('telescope.builtin').live_grep({cwd = "."})<CR>
" nnoremap <C-P> :lua require('telescope.builtin').find_files({cwd = "."})<CR>
" nnoremap <C-\> :lua require('telescope.builtin').find_files({cwd = "."})<CR>
nnoremap <C-G> :Telescope live_grep<cr>
nnoremap <C-P> :Telescope find_files<cr>
" ============================================================================

" Clear terminal (nvim ternimal equivalent to bash 'reset')
tnoremap <C-l> <C-\><C-n>:call ClearTerminal()<cr>

let s:scroll_value = 1000
function! ClearTerminal()
  set scrollback=1
  let &g:scrollback=1
  echo &scrollback
  call feedkeys("\i")
  call feedkeys("clear\<CR>")
  call feedkeys("\<C-\>\<C-n>")
  call feedkeys("\i")
  sleep 100m
  let &scrollback=s:scroll_value
endfunction

" Quick commands - goto EdgeAI, goto Home
map EE :cd ~/Codes/EdgeAI<CR>
map EH :cd ~/<CR>

map <A-1> <C-w>h
map <A-2> <C-w>l
set mouse=a
" tnoremap   <silent>   <A-1>    <C-\><C-n>:FloatermFirst<CR>
" tnoremap   <silent>   <A-2>    <C-\><C-n>:FloatermLast<CR>

" Easy config edit
nnoremap <A-)> :edit ~/.config/nvim/init.vim<CR>
" Easy re-source
noremap <A-0> :source ~/.config/nvim/init.vim <CR>

" Shortcut for :Kwbd (Keep window, close buffer)
nnoremap <C-d> :Kwbd<CR>

if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

:runtime pretty.vim
:runtime term_setup.vim
:runtime vim_setup.lua
