-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Enable full color and highlighting support
vim.opt.termguicolors = true

-- Mason
require("mason").setup()

-- Nvim-Tree
require("nvim_tree_setup")

-- Setup nvim-cmp: Autocompletion ---------------------------------------------
local cmp = require('cmp')

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  experimental = {
    ghost_text = true,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
    ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'cmdline' },
  })
})

-- Setup lspconfig
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local navic = require("nvim-navic")
navic.setup {
    icons = {
        File          = " ",
        Module        = " ",
        Namespace     = " ",
        Package       = " ",
        Class         = " ",
        Method        = " ",
        Property      = " ",
        Field         = " ",
        Constructor   = " ",
        Enum          = "練",
        Interface     = "練",
        Function      = " ",
        Variable      = " ",
        Constant      = " ",
        String        = " ",
        Number        = " ",
        Boolean       = "◩ ",
        Array         = " ",
        Object        = " ",
        Key           = " ",
        Null          = "ﳠ ",
        EnumMember    = " ",
        Struct        = " ",
        Event         = " ",
        Operator      = " ",
        TypeParameter = " ",
    },
    highlight = false,
    separator = " > ",
    depth_limit = 0,
    depth_limit_indicator = "..",
}

-- Setup Clangd (C/C++ languange server) --------------------------------------
require('lspconfig')['clangd'].setup({
  capabilities = capabilities,
  cmd = { "clangd-9", "--background-index", "--header-insertion=never"},
  on_attach = function(client, bufnr)
      navic.attach(client, bufnr)
  end
})

-- Setup ZLS (Zig Language Server) --------------------------------------------
local zls_on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    navic.attach(client, bufnr)
end
require('lspconfig')['zls'].setup({
  capabilities = capabilities,
  on_attach = zls_on_attach,
})

vim.diagnostic.config({virtual_text = false})
vim.diagnostic.config({signs = false})
vim.diagnostic.config({underline = false})

-- diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Disable underline, it's very annoying
        underline = false,
        virtual_text = false,
        -- Enable virtual text, override spacing to 4
        -- virtual_text = {spacing = 4},
        -- Use a function to dynamically turn signs off and on, using buffer local variables
        -- signs = true,
        update_in_insert = false
    })

-- Setup TreeSitter -----------------------------------------------------------
require('nvim-treesitter.configs').setup {
  ensure_installed = {"c", "cpp", "rust", "toml", "zig", "lua", "vim", "python", "bash"},
  highlight = {
    enable = true,
    custom_captures = {
      -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
      ["foo.bar"] = "Identifier",
    },
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

require('nvim-treesitter.configs').setup {
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}

-- Setup Lualine (statusbar) --------------------------------------------------
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename', {'navic', color_correction = true, navic_opts = nil}},
    lualine_x = {'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {
    -- lualine_a = {'navic', color_correction = nil, navic_opts = nil},
  },
  extensions = {},
}

-- Super nice Git diff view! --------------------------------------------------
-- Usage:
--   DiffviewOpen (equivalent to 'git diff')
--   DiffviewOpen HEAD~2 (equivalent to 'git diff HEAD~2')
--   DiffviewClose (close diff view when done)
local cb = require('diffview.config').diffview_callback

require('diffview').setup {
  diff_binaries = false,    -- Show diffs for binaries
  enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
  use_icons = true,         -- Requires nvim-web-devicons
  icons = {                 -- Only applies when use_icons is true.
    folder_closed = "",
    folder_open = "",
  },
  signs = {
    fold_closed = "",
    fold_open = "",
  },
  file_panel = {
    win_config = {
        position = "left",                  -- One of 'left', 'right', 'top', 'bottom'
        width = 35,                         -- Only applies when position is 'left' or 'right'
        height = 10,                        -- Only applies when position is 'top' or 'bottom'
        listing_style = "tree",             -- One of 'list' or 'tree'
        tree_options = {                    -- Only applies when listing_style is 'tree'
          flatten_dirs = true,              -- Flatten dirs that only contain one single dir
          folder_statuses = "only_folded",  -- One of 'never', 'only_folded' or 'always'.
        },
    },
  },
  file_history_panel = {
    win_config = {
        position = "bottom",
        width = 35,
        height = 16,
        log_options = {
          max_count = 256,      -- Limit the number of commits
          follow = false,       -- Follow renames (only for single file)
          all = false,          -- Include all refs under 'refs/' including HEAD
          merges = false,       -- List only merge commits
          no_merges = false,    -- List no merge commits
          reverse = false,      -- List commits in reverse order
        },
    },
  },
  default_args = {    -- Default args prepended to the arg-list for the listed commands
    DiffviewOpen = {},
    DiffviewFileHistory = {},
  },
  hooks = {},         -- See ':h diffview-config-hooks'
  key_bindings = {
    disable_defaults = false,                   -- Disable the default key bindings
    -- The `view` bindings are active in the diff buffers, only when the current
    -- tabpage is a Diffview.
    view = {
      ["<tab>"]      = cb("select_next_entry"),  -- Open the diff for the next file
      ["<s-tab>"]    = cb("select_prev_entry"),  -- Open the diff for the previous file
      ["gf"]         = cb("goto_file"),          -- Open the file in a new split in previous tabpage
      ["<C-w><C-f>"] = cb("goto_file_split"),    -- Open the file in a new split
      ["<C-w>gf"]    = cb("goto_file_tab"),      -- Open the file in a new tabpage
      ["<leader>e"]  = cb("focus_files"),        -- Bring focus to the files panel
      ["<leader>b"]  = cb("toggle_files"),       -- Toggle the files panel.
    },
    file_panel = {
      ["j"]             = cb("next_entry"),           -- Bring the cursor to the next file entry
      ["<down>"]        = cb("next_entry"),
      ["k"]             = cb("prev_entry"),           -- Bring the cursor to the previous file entry.
      ["<up>"]          = cb("prev_entry"),
      ["<cr>"]          = cb("select_entry"),         -- Open the diff for the selected entry.
      ["o"]             = cb("select_entry"),
      ["<2-LeftMouse>"] = cb("select_entry"),
      ["-"]             = cb("toggle_stage_entry"),   -- Stage / unstage the selected entry.
      ["S"]             = cb("stage_all"),            -- Stage all entries.
      ["U"]             = cb("unstage_all"),          -- Unstage all entries.
      ["X"]             = cb("restore_entry"),        -- Restore entry to the state on the left side.
      ["R"]             = cb("refresh_files"),        -- Update stats and entries in the file list.
      ["<tab>"]         = cb("select_next_entry"),
      ["<s-tab>"]       = cb("select_prev_entry"),
      ["gf"]            = cb("goto_file"),
      ["<C-w><C-f>"]    = cb("goto_file_split"),
      ["<C-w>gf"]       = cb("goto_file_tab"),
      ["i"]             = cb("listing_style"),        -- Toggle between 'list' and 'tree' views
      ["f"]             = cb("toggle_flatten_dirs"),  -- Flatten empty subdirectories in tree listing style.
      ["<leader>e"]     = cb("focus_files"),
      ["<leader>b"]     = cb("toggle_files"),
    },
    file_history_panel = {
      ["g!"]            = cb("options"),            -- Open the option panel
      ["<C-A-d>"]       = cb("open_in_diffview"),   -- Open the entry under the cursor in a diffview
      ["y"]             = cb("copy_hash"),          -- Copy the commit hash of the entry under the cursor
      ["zR"]            = cb("open_all_folds"),
      ["zM"]            = cb("close_all_folds"),
      ["j"]             = cb("next_entry"),
      ["<down>"]        = cb("next_entry"),
      ["k"]             = cb("prev_entry"),
      ["<up>"]          = cb("prev_entry"),
      ["<cr>"]          = cb("select_entry"),
      ["o"]             = cb("select_entry"),
      ["<2-LeftMouse>"] = cb("select_entry"),
      ["<tab>"]         = cb("select_next_entry"),
      ["<s-tab>"]       = cb("select_prev_entry"),
      ["gf"]            = cb("goto_file"),
      ["<C-w><C-f>"]    = cb("goto_file_split"),
      ["<C-w>gf"]       = cb("goto_file_tab"),
      ["<leader>e"]     = cb("focus_files"),
      ["<leader>b"]     = cb("toggle_files"),
    },
    option_panel = {
      ["<tab>"] = cb("select"),
      ["q"]     = cb("close"),
    },
  },
}

-- Telescope: Extensible (and pretty) fuzzy finder ----------------------------
require('telescope').setup{
  defaults = {
    sorting_strategy = 'ascending',
    layout_config = {
      prompt_position = 'top',
    },
  },
  pickers = {
    find_files = {
      -- no_ignore = true, -- ignore .gitignore
    }
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}
require('telescope').load_extension('fzf')

-- Rust language support setup
local rt = require("rust-tools")

rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})

--- Glow (Markdown preview) config
require('glow').setup({
  style = "dark",
  width = 150,
})

-- Colorscheme Customization --------------------------------------------------
-- For NeoVim 0.8:
if vim.api.nvim_call_function("has", { "nvim-0.8" }) == 1 then
  lsp_highlights = {
    ["comment"] = {fg = '$comment_pink'},
    ["@comment"] = {fg = '$comment_pink'},
  }
end

-- For NeoVim 0.9:
if vim.api.nvim_call_function("has", { "nvim-0.9" }) == 1 then
  lsp_highlights = {
    ["comment"] = {fg = '$comment_pink'},
    ["@comment"] = {fg = '$comment_pink'},
    ["@lsp.type.comment"] = {fg = '$comment_pink'},
  }
end

-- OneDark color scheme customizations
require('onedark').setup({
  style = 'dark',
  transparent = false,

  -- toggle theme style ---
  toggle_style_key = "<leader>ts",
  toggle_style_list = {'dark', 'cool', 'deep', 'warm'},

  colors = {
    comment_pink = "#ee55a0",  -- My custom bright comment colors
    comment_coral = "#d46398",
  },
  highlights = lsp_highlights,
})
require('onedark').load()

-- Hologram image renderer
-- Still a bit unstable, but neat!
-- require('hologram').setup({
--   auto_display = true,
-- })
