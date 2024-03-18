local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
    -- Install server automatically
    automatic_installation = true,
})

mason_lspconfig.setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function(server_name)  -- default handler (optional)
        lspconfig[server_name].setup {}
    end,

    -- Next, you can provide a dedicated handler for specific servers.
    -- For example, a handler override for the `rust_analyzer`:
    ["rust_analyzer"] = function()
        require("rust-tools").setup {}
    end,

    ["clangd"] = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
        capabilities.textDocument.semanticHighlighting = true
        capabilities.offsetEncoding = { "utf-16" }

        lspconfig.clangd.setup({
            capabilities = capabilities,
        })
    end,

    ["cssls"] = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        lspconfig.cssls.setup({
            capabilities = capabilities,
        })
    end,

    ["html"] = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        lspconfig.html.setup({
            capabilities = capabilities,
        })
    end,

    ["jsonls"] = function()
        lspconfig.jsonls.setup({
            settings = {
                json = {
                    schemas = require('schemastore').json.schemas(),
                    validate = { enable = true },
                }
            }
        })
    end,

    ["yamlls"] = function()
        lspconfig.yamlls.setup({
            settings = {
                yaml = {
                    schemaStore = {
                        enable = false,
                        url = "",
                    },
                    schemas = require("schemastore").yaml.schemas(),
                }
            }
        })
    end,

    ["ruff_lsp"] = function()
        lspconfig.ruff_lsp.setup({
        })
    end,

}
