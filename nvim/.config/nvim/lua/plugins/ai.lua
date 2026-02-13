return {
    {
        "zbirenbaum/copilot.lua",
        requires = {
            "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
            init = function()
                vim.g.copilot_nes_debounce = 100
            end,
        },
        cmd = { "Copilot" },
        event = { "InsertEnter" },
        config = function()
            require("copilot").setup({
                suggestion = {
                    auto_trigger = true,
                    keymap = {
                        accept = "<Tab>",
                        next = "<C-.>",
                        prev = "<C-,>",
                    },
                },
                nes = {
                    enabled = true,
                    keymap = {
                        accept_and_goto = "<Tab>",
                        accept = false,
                        dismiss = "<Esc>",
                    },
                },
            })
        end,
    },
    {
        "polacekpavel/prompt-yank.nvim",
        cmd = { "PromptYank" },
        keys = {
            -- { "<Leader>yp", mode = { "n", "v" }, desc = "PromptYank: file/selection" },
            -- { "<Leader>ym", mode = "n",          desc = "PromptYank: multi-file" },
            -- { "<Leader>yd", mode = { "n", "v" }, desc = "PromptYank: diff" },
            -- { "<Leader>yb", mode = { "n", "v" }, desc = "PromptYank: blame" },
            -- { "<Leader>ye", mode = "v",          desc = "PromptYank: diagnostics" },
            -- { "<Leader>yt", mode = { "n", "v" }, desc = "PromptYank: tree" },
            -- { "<Leader>yr", mode = { "n", "v" }, desc = "PromptYank: remote URL" },
            -- { "<Leader>yf", mode = "n",          desc = "PromptYank: function" },
            -- { "<Leader>yl", mode = "v",          desc = "PromptYank: selection + definitions" },
            -- { "<Leader>yL", mode = "v",          desc = "PromptYank: selection + deep definitions" },
            -- { "<Leader>yR", mode = "n",          desc = "PromptYank: related files" },
            { "<Leader>ca", mode = { "n", "v" }, desc = "PromptYank: file/selection" },
            { "<Leader>cf", mode = "n",          desc = "PromptYank: function" },
        },
        opts = {},
        config = function(_, opts)
            require("prompt-yank").setup(opts)
        end,
    },
}
