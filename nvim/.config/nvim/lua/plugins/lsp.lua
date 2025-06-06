return {
    {
        "neovim/nvim-lspconfig",
        config = function()
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
            require("mason-lspconfig").setup()
        end,
    },
    {
        "saghen/blink.cmp",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        version = "1.*",
        opts = {
            keymap = { preset = "enter" },
            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 100,
                },
            },
            sources = {
                -- add lazydev to your completion providers
                default = { "lazydev", "lsp", "path", "snippets", "buffer" },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        -- make lazydev completions top priority (see `:h blink.cmp`)
                        score_offset = 100,
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
