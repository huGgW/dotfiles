return {
    {
        "zbirenbaum/copilot.lua",
        requires = {
            "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
            init = function()
                vim.g.copilot_nes_debounce = 500
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
}
