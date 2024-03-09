" Quick commands - goto EdgeAI, goto Home
map HH :cd ~/<CR>
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

function! ANSIEscapeLogFile()
  :AnsiEsc
  :StripWhitespace
  silent :execute '! dos2unix -f %' | silent edit! %
  silent :%s///g
endfunction
command! ANSILog call ANSIEscapeLogFile()
