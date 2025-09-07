return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.lsp.config('gopls', {
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
            })
            -- enable inlay hint
            vim.lsp.inlay_hint.enable()
        end,
    },
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                automatic_enable = {
                    exclude = {}
                }
            })
        end,
    },
    {
        "saghen/blink.cmp",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "copilotlsp-nvim/copilot-lsp",
            "fang2hou/blink-copilot",
        },
        version = "1.*",
        opts = {
            keymap = {
                preset = "enter",
                ["<Tab>"] = {
                    function(cmp)
                        if vim.b[vim.api.nvim_get_current_buf()].nes_state then
                            cmp.hide()
                            return (
                                require("copilot-lsp.nes").apply_pending_nes()
                                and require("copilot-lsp.nes").walk_cursor_end_edit()
                            )
                        end
                        if cmp.snippet_active() then
                            return cmp.accept()
                        else
                            return cmp.select_and_accept()
                        end
                    end,
                    "snippet_forward",
                    "fallback",
                },
            },
            completion = {
                accept = {
                    resolve_timeout_ms = 300,
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 100,
                },
                menu = {
                    direction_priority = { 'n', 's' },
                },
                ghost_text = {
                    enabled = true,
                    show_with_selection = true,
                    show_without_selection = false,
                    show_with_menu = true,
                    show_without_menu = true,
                },
            },
            sources = {
                default = { "copilot", "lazydev", "lsp", "path", "snippets", "buffer" },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                    copilot = {
                        name = "copilot",
                        module = "blink-copilot",
                        score_offset = 1,
                        async = true,
                    },
                },
            },
            signature = {
                enabled = true,
            }
        },
    },
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>fm",
                function()
                    require("conform").format({ async = true })
                end,
                mode = "",
                desc = "Format buffer",
            },
        },
        opts = {
            formatters_by_ft = {
                go = { "goimports", "gofumpt" },
                typescript = { "biome" },
                javascript = { "biome" },
                typescriptreact = { "biome" },
                javascriptreact = { "biome" },
                json = { "biome" },
            },
            default_format_opts = {
                lsp_format = "fallback",
            },
            format_on_save = { timeout_ms = 1000 },
        },
    },
    {
        "mfussenegger/nvim-lint",
        event = { "BufRead" },
        config = function()
            require("lint").linters_by_ft = {
                go = { "golangcilint" },
            }
        end,
    },
    {
        "RRethy/vim-illuminate",
        event = { "BufRead" },
    },

    -- language specifics
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
}
