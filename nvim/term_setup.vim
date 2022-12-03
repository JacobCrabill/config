" Terminal mode: Allow ESC to exit insert mode
tnoremap <Esc> <C-\><C-n>

" Create a new Floaterm on startup, hide it, then setup ctrl+t to toggle it
function InitFloaterm()
  :FloatermKill!
  :FloatermNew --width=0.5 --height=0.7
  :stopinsert
  :FloatermHide
endfunction
nnoremap <C-t> :FloatermToggle<cr>
tnoremap <C-t> <C-\><C-n>:FloatermToggle<cr>

" Add Floaterm setup upon NeoVim startup to our vimrc augroup
augroup vimrc
  autocmd VimEnter * :call InitFloaterm()
augroup END

" -------------------------------------------
" Sample command for a more complex use case:
" :FloatermNew --width=0.5 --height=1.0 --name=A --cwd=~/Codes/EdgeAI --wintype=vsplit --position=aboveleft shieldup
" -------------------------------------------
