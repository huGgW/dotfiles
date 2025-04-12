return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
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
                },
            },
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
            },
            default_format_opts = {
                lsp_format = "fallback",
            },
            format_on_save = { timeout_ms = 500 },
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

    -- laguage specific
    {
        'nvim-java/nvim-java',
        ft = { "java" },
        event = { "BufReadPre" },
        config = function()
            require('java').setup({
                jdk = {
                    auto_install = false,
                },
            })
        end
    }
}
