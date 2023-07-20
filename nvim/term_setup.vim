" Terminal mode: Allow ESC to exit insert mode
tnoremap <Esc> <C-\><C-n>

let g:floaterm_width = 0.6
let g:floaterm_height = 0.75

" Create a new Floaterm on startup, hide it, then setup ctrl+t to toggle it
function InitFloaterm()
  :FloatermKill!
  :FloatermNew
  :stopinsert
  :FloatermHide
endfunction

nnoremap <C-t> :FloatermToggle<cr>
nnoremap <A-t> :FloatermNext<cr>
nnoremap <A-T> :FloatermPrev<cr>
nnoremap <C-x><C-t> :FloatermNew<cr>
tnoremap <C-t> <C-\><C-n>:FloatermToggle<cr>
tnoremap <A-t> <C-\><C-n>:FloatermNext<cr>
tnoremap <A-T> <C-\><C-n>:FloatermPrev<cr>
tnoremap <C-x><C-t> <C-\><C-n>:FloatermNew<cr>

" Add Floaterm setup upon NeoVim startup to our vimrc augroup
augroup vimrc
  autocmd VimEnter * :call InitFloaterm()
augroup END

" Clear terminal (nvim ternimal equivalent to bash 'reset')
let s:scroll_value = 5000
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
tnoremap <C-l> <C-\><C-n>:call ClearTerminal()<cr>

" -------------------------------------------
" Sample command for a more complex use case:
" :FloatermNew --width=0.5 --height=1.0 --name=A --cwd=~/Codes/EdgeAI --wintype=vsplit --position=aboveleft shieldup
" -------------------------------------------
