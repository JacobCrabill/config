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

