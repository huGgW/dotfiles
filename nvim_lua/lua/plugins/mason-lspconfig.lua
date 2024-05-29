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
    function(server_name) -- default handler (optional)
        lspconfig[server_name].setup {}
    end,

    -- Next, you can provide a dedicated handler for specific servers.
    -- For example, a handler override for the `rust_analyzer`:

    -- kotlin
    ["kotlin_language_server"] = function()
        lspconfig.kotlin_language_server.setup({
            settings = {
                kotlin = {
                    inlayHints = {
                        typeHints = true,
                        parameterHints = true,
                        chainedHints = true,
                    },
                },
            }
        })
    end,

    -- python
    ["basedpyright"] = function()
        lspconfig.basedpyright.setup({
            basedpyright = {
                analysis = {
                    typeCheckingMode = "strict",
                    autoSearchPaths = true,
                    diagnosticMode = "openFilesOnly",
                    useLibraryCodeForTypes = true
                }
            }
        })
    end,

    ["ruff_lsp"] = function()
        lspconfig.ruff_lsp.setup({
        })
    end,

    -- go
    ["gopls"] = function()
        lspconfig.gopls.setup({
            settings = {
                gopls = {
                    hints = {
                        rangeVariableTypes = true,
                        parameterNames = true,
                        compositeLiteralFields = true,
                        compositeLiteralTypes = true,
                        functionTypeParameters = true,
                        constantValues = true,
                        assingVariableTypes = true,
                    }
                }
            }
        })
    end,

    -- rust
    ["rust_analyzer"] = function()
        lspconfig.rust_analyzer.setup({
            on_attach = function(client, bufnr)
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end,
        })
    end,

    -- c / c++
    ["clangd"] = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
        capabilities.textDocument.semanticHighlighting = true
        capabilities.offsetEncoding = { "utf-16" }

        lspconfig.clangd.setup({
            capabilities = capabilities,
            settings = {
                clangd = {
                    InlayHints = {
                        Designators = true,
                        Enabled = true,
                        ParameterNames = true,
                        DeducedTypes = true,
                    },
                    fallbackFlags = { "-std=c++20" }
                }
            }
        })
    end,

    -- lua
    ["lua_ls"] = function()
        lspconfig.lua_ls.setup({
            settings = {
                Lua = {
                    hint = {
                        enable = true,
                    }
                }
            }
        })
    end,

    -- typescript
    ["tsserver"] = function()
        require("typescript-tools").setup({
            settings = {
                tsserver_file_preferences = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                }
            }
        })
    end,

    -- css
    ["cssls"] = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        lspconfig.cssls.setup({
            capabilities = capabilities,
        })
    end,

    -- html
    ["html"] = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        lspconfig.html.setup({
            capabilities = capabilities,
        })
    end,

    -- json
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

    -- yaml
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
}
