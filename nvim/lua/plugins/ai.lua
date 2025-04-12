return {
    {
        "zbirenbaum/copilot.lua",
        cmd = { "Copilot" },
        event = { "InsertEnter" },
        config = function()
            require("copilot").setup({
                suggestion = {
                    keymap = {
                        accept = "<Tab>",
                        next = "<C-.>",
                        prev = "<C-,>",
                    },
                },
                copilot_model = "gpt-4o-copilot",
            })
        end,
    },
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        event = { "VeryLazy" },
        cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
        opts = {
            strategies = {
                chat = {
                    adapter = "copilot",
                },
                inline = {
                    adapter = "copilot",
                },
                cmd = {
                    adapter = "copilot",
                },
            },
            adapters = {
                copilot = function()
                    return require('codecompanion.adapters').extend('copilot', {
                        model = {
                            default = "claude-3.7-sonnet",
                        },
                        reasoning_effort = {
                            default = "high",
                        },
                    })
                end,
            },
        },
        keys = {
            { "<leader>ce", "<cmd>CodeCompanion<cr>",         mode = { "n", "v" },            desc = "Code Companion Inline" },
            { "<leader>ca", "<cmd>CodeCompanionChat<cr>",     mode = { "n" },                 desc = "Code Companion Chat" },
            { "<leader>ca", "<cmd>CodeCompanionChat Add<cr>", mode = { "v" },                 desc = "Code Companion Chat Add" },
            { "<leader>ca", "<cmd>CodeCompanionActions<cr>",  desc = "Code Companion Actions" },
        },
    },
}
