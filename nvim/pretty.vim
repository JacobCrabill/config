" ======== Colorscheme Config ========
highlight Normal guibg=NONE ctermbg=NONE
set background=dark

" " ==== Silicon Config (Render code to .png)
" let g:silicon = {
"       \   'theme':          'OneHalfDark',
"       \   'font':                  'Hack',
"       \   'background':         '#010101',
"       \   'shadow-color':       '#555555',
"       \   'line-pad':                   2,
"       \   'pad-horiz':                  0,
"       \   'pad-vert':                   0,
"       \   'shadow-blur-radius':         0,
"       \   'shadow-offset-x':            0,
"       \   'shadow-offset-y':            0,
"       \   'line-number':           v:true,
"       \   'round-corner':          v:true,
"       \   'window-controls':       v:false,
"       \ }
" ==== Silicon Config (Render code to .png)
let g:silicon = {
      \   'theme':          'OneHalfDark',
      \   'background':         '#000000',
      \   'pad-horiz':                  0,
      \   'pad-vert':                   0,
      \   'window-controls':       v:false,
      \   'output': '~/Documents/Silicon/silicon-{time:%Y-%m-%d-%H%M%S}.png',
      \ }
