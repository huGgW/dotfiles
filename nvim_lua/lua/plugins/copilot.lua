require("copilot").setup({
    suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
            accept = "<Tab>",
        }
    },
    filetypes = {
        ["*"] = true
    }
})
