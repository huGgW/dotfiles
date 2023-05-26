require("mason-lspconfig").setup({
    -- Install server automatically
    automatic_installation = true,
})

require("mason-lspconfig").setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function (server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {}
    end,

    -- Next, you can provide a dedicated handler for specific servers.
    -- For example, a handler override for the `rust_analyzer`:
    -- ["rust_analyzer"] = function ()
    --     require("rust-tools").setup {}
    -- end
    ["clangd"] = function ()
        local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
        capabilities.textDocument.semanticHighlighting = true
        capabilities.offsetEncoding = { "utf-8" }

        require("lspconfig").clangd.setup({
            capabilities = capabilities,
        })
    end
}
