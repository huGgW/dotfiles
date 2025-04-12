local configs = {
    -- core languages

    gopls = {
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        single_file_support = true,
        settings = {
            gopls = {
                hints = {
                    rangeVariableTypes = true,
                    parameterNames = true,
                    constantValues = true,
                    assignVariableTypes = false,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    functionTypeParameters = true,
                },
            }
        },
    },
    jdtls = {
        cmd = { "jdtls" },
        filetypes = { "java" },
        single_file_support = true,
        init_options = {
            jvm_args = { 'Xmx4g' },
        },
    },

    -- frontend related languages

    ts_ls = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
        init_options = {
            hostInfo = "neovim",
        },
        single_file_support = true,
        settings = {
            typescript = {
                inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
            javascript = {
                inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
        },
    },

    html = {
        cmd = { "vscode-html-language-server", "--stdio" },
        filetypes = { "html", "templ" },
        init_options = {
            configurationSection = { "html", "css", "javascript" },
            embeddedLanguages = {
                css = true,
                javascript = true,
            },
            provideFormatter = true,
        },
        single_file_support = true,
    },

    -- config langauges

    lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        single_file_support = true,
    },

    jsonls = {
        cmd = { "vscode-json-language-server", "--stdio" },
        filetypes = { "json", "jsonc" },
        init_options = {
            provideFormatter = true
        },
        single_file_support = true,
    },

    yamlls = {
        cmd = { "yaml-language-server", "--stdio" },
        filetypes = { "yaml", "yml", "yaml.docker-compose", "yaml.gitlab" },
        settings = {
            redhat = {
                telemetry = {
                    enabled = false
                }
            }
        },
        single_file_support = true,
    },

    terraformls = {
        cmd = { "terraform-ls", "serve" },
        filetypes = { "terraform", "terraform-vars" },
    },
}


for lsp, cfg in pairs(configs) do
    vim.lsp.config(lsp, cfg)
end

vim.lsp.enable(vim.tbl_keys(configs))
vim.lsp.inlay_hint.enable()
