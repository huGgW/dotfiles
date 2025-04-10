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
}
