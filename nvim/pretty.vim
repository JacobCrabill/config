" ======== Colorscheme Config ========
highlight Normal guibg=NONE ctermbg=NONE
set background=dark

let s:my_scheme = "onedark"

if s:my_scheme == "nightfox"
  " ---- Nightfox schemes
  colorscheme carbonfox
elseif s:my_scheme == "onedark"
  " ---- OneDark scheme
  let g:onedark_terminal_italics = 1

  " Adjust the OneDark colorscheme config
  if (has("autocmd"))
    augroup colorset
      autocmd!
      let s:comment = { "gui": "#EE55E0", "cterm": "213", "cterm16": "13" }
      autocmd ColorScheme * call onedark#set_highlight("Comment", { "fg": s:comment })
    augroup END
  endif
  colorscheme onedark
elseif s:my_scheme == "palenight"
  " ---- Palenight scheme
  colorscheme palenight
  let g:palenight_terminal_italics=1
  let g:palenight_color_overrides = {
  \    'comment_grey': { "gui": "#EE55E0", "cterm": "213", "cterm16": "13" },
  \}
endif

