require("copilot").setup({
    suggestion = {
        enabled = true,
        auto_trigger = false,
        keymap = {
            accept = "<Tab>",
            next = "<C-.>",
            prev = "<C-,>",
        }
    },
    filetypes = {
        ["*"] = true
    }
})
