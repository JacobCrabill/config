" ======== Colorscheme Config ========
highlight Normal guibg=NONE ctermbg=NONE
set background=dark

let s:my_scheme = "onedark"

if s:my_scheme == "nightfox"
  " ---- Nightfox schemes
  colorscheme carbonfox
elseif s:my_scheme == "onedark"
  " ---- OneDark scheme - Configured in Lua init
  colorscheme onedark
elseif s:my_scheme == "palenight"
  " ---- Palenight scheme
  colorscheme palenight
  let g:palenight_terminal_italics=1
  let g:palenight_color_overrides = {
  \    'comment_grey': { "gui": "#EE55E0", "cterm": "213", "cterm16": "13" },
  \}
elseif s:my_scheme == "tokyonight"
lua << EOF
  require("tokyonight").setup({
    style = "storm",
    on_colors = function(colors)
      colors.comment = "#d46390"
    end
  })
EOF
  colorscheme tokyonight-storm
endif

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
