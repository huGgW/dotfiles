return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- enable locally installed servers
            -- other servers will be enabled via mason-lspconfig
            vim.lsp.enable("gleam")

            -- config for pre-defined servers by mason
            -- go
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

    -- language specifics
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                vim.env.VIMRUNTIME,
                { path = "${3rd}/luv/library",    words = { "vim%.uv" } },
                { path = "${3rd}/busted/library", words = { "vim%.uv" } },
                vim.lsp.enable('lua')
            },
        },
    },
    {
        'mrcjkb/rustaceanvim',
        version = '^6',
        lazy = false, -- This plugin is already lazy

    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        opts = {},
    },
    {
        'nvim-java/nvim-java',
        ft = { 'java' },
        config = function()
            require('java').setup({
            })

            vim.lsp.config("jdtls", {
                settings = {
                    java = {
                        jdt = {
                            ls = {
                                lombokSupport = {
                                    enabled = true
                                },
                                vmargs =
                                "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx16G -Xms1G",
                            }
                        },
                        compile = {
                            nullAnalysis = {
                                mode = "automatic"
                            },
                        },
                    },
                },
            })

            vim.lsp.enable('jdtls')
        end,
    },

    -- autocompletion
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
                default = { "lazydev", "lsp", "path", "snippets", "buffer" },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                },
            },
            signature = {
                enabled = true,
            }
        },
    },

    -- formatter, linter
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
                go = { "gofumpt" },
                typescript = { "biome" },
                javascript = { "biome" },
                typescriptreact = { "biome" },
                javascriptreact = { "biome" },
                json = { "biome" },
                python = { "ruff" },
            },
            default_format_opts = {
                lsp_format = "fallback",
            },
            format_on_save = { timeout_ms = 3000 },
        },
    },
    {
        "mfussenegger/nvim-lint",
        event = { "BufRead" },
        config = function()
            require("lint").linters_by_ft = {
            }

            vim.api.nvim_create_autocmd({ "BufReadPost" }, {
                callback = function()
                    require("lint").try_lint()
                end,
            })

            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                callback = function()
                    require("lint").try_lint()
                end,
            })
        end,
    },

    {
        "RRethy/vim-illuminate",
        event = { "BufRead" },
    },
}
