-- Enable Lua / NeoVim API support
require('neodev').setup({})

-- Setup lspconfig
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local lspconfig = require('lspconfig')

local navic = require("nvim-navic")
navic.setup {
    icons = {
        File          = "󰈙 ",
        Module        = " ",
        Namespace     = "󰌗 ",
        Package       = " ",
        Class         = "󰌗 ",
        Method        = "󰆧 ",
        Property      = " ",
        Field         = " ",
        Constructor   = " ",
        Enum          = "󰕘",
        Interface     = "󰕘",
        Function      = "󰊕 ",
        Variable      = "󰆧 ",
        Constant      = "󰏿 ",
        String        = " ",
        Number        = "󰎠 ",
        Boolean       = "◩ ",
        Array         = "󰅪 ",
        Object        = "󰅩 ",
        Key           = "󰌋 ",
        Null          = "󰟢 ",
        EnumMember    = " ",
        Struct        = "󰌗 ",
        Event         = " ",
        Operator      = "󰆕 ",
        TypeParameter = "󰊄 ",
    },
    highlight = false,
    separator = " > ",
    depth_limit = 0,
    depth_limit_indicator = "..",
}

----------------------------------------------------------------
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled
----------------------------------------------------------------

-- C++ Language Server (clangd)
local clangd_on_attach = function(client, bufnr)
    require('completion').on_attach()
    navic.attach(client, bufnr)
end
lspconfig.clangd.setup {
  capabilities = capabilities,
  cmd = { "clangd-12", "--background-index", "--header-insertion=never"},
  on_attach = clangd_on_attach,
}

-- Zig Language Server (ZLS)
local zls_on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, nil)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, nil)
    vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, nil)
    -- Turn off semantic tokens overriding our current highlighting
    -- See: https://github.com/neovim/neovim/pull/21100
    -- client.server_capabilities.semanticTokensProvider = nil
    require('completion').on_attach()
    navic.attach(client, bufnr)
end
lspconfig.zls.setup {
  capabilities = capabilities,
  on_attach = zls_on_attach,
}

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

-- Lua language support (including NeoVim APIs)
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      }
    }
  }
})

----------------------------------------------------------------
-- Diagnostics Setup
----------------------------------------------------------------

vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Use a function to dynamically turn signs off
        -- and on, using buffer local variables
        signs = true,

        -- Enable/Disable underline squiggles
        underline = true,

        -- Enable virtual text, override spacing to 4
        -- virtual_text = {spacing = 4},
        virtual_text = true,

        -- Diable showing of diagnostics in insert mode
        update_in_insert = false
    })
