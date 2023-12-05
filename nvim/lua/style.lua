--- Glow (Markdown preview) config
require('glow').setup({
  style = "dark",
  width = 150,
})

-- OneDark Color Scheme config
require('onedark').setup({
  style = 'dark',
  transparent = false,

  -- toggle theme style ---
  toggle_style_key = "<leader>ts",
  -- Available styles: dark(er), cool, deep, warm(er)
  toggle_style_list = {'dark', 'darker', 'cool', 'warm'},

  -- Turn off italics for comments
  code_style = {
      comments = 'none',
  },

  colors = {
    comment_pink = "#ee55a0",    -- My custom bright comment colors
    comment_coral = "#d46398",
  },
  highlights = {
    ["@Comment"] = {fg = '$comment_pink'},  -- Treesitter comments
    Comment = {fg = '$comment_pink'},       -- Non-TS comments
  }
})
require('onedark').load()

-- vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
