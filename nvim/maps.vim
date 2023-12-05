" Quick commands - goto EdgeAI, goto Home
" map EE :cd ~/Codes/EdgeAI<CR>
" map EC :cd ~/Codes/EdgeAI/src/extern/CommonTaskBehaviorFoundations<CR>
" map EX :cd ~/Codes/EdgeAI/src/subsystems/executive_manager<CR>
" map EA :cd ~/Codes/EdgeAI/src/subsystems/automode<CR>
map HH :cd ~/<CR>
" map <leader>ee :cd ~/Codes/EdgeAI<CR>
" map <leader>ec :cd ~/Codes/EdgeAI/src/extern/CommonTaskBehaviorFoundations<CR>
" map <leader>ex :cd ~/Codes/EdgeAI/src/subsystems/executive_manager<CR>
" map <leader>ea :cd ~/Codes/EdgeAI/src/subsystems/automode<CR>
map <leader>vbat :cd ~/Codes/vbats<CR>
map <leader>coco :cd ~/Codes/coco<CR>

" Enable/Disable Cue auto-formatting (Enabled by default)
let g:cue_fmt_on_save = 1
function! SetCueFmtOnSave(value)
  let g:cue_fmt_on_save = a:value
  echo printf("Set cue_fmt_on_save to %d", + a:value)
endfunction
command! CueFormatEnable  call SetCueFmtOnSave(1)
command! CueFormatDisable call SetCueFmtOnSave(0)
