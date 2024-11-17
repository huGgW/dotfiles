local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")
-- local function blinkcapabilities()
--     return require('blink.cmp').get_lsp_capabilities(nil, true)
-- end

mason_lspconfig.setup({
})

mason_lspconfig.setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function(server_name) -- default handler (optional)
        lspconfig[server_name].setup {
        }
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
        -- ignore since we use rustacean.nvim

        -- lspconfig.rust_analyzer.setup({
        --     on_attach = function(client, bufnr)
        --         vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        --     end,
        -- })
    end,

    -- c / c++
    ["clangd"] = function()
        lspconfig.clangd.setup({
            capabilities = {
                textDocument = {
                    semanticHighlighting = true,
                },
                offsetEncoding = { "utf-16" },
            },
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
    ["ts_ls"] = function()
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
        lspconfig.cssls.setup({
            capabilities = {
                textDocument = {
                    completion = {
                        completionItem = {
                            snippetSupport = true,
                        }
                    }
                }
            },
        })
    end,

    -- html
    ["html"] = function()
        lspconfig.html.setup({
            capabilities = {
                textDocument = {
                    completion = {
                        completionItem = {
                            snippetSupport = true,
                        }
                    }
                }
            },
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
