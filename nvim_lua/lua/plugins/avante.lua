local function setup()
    require('avante_lib').load()
    require('avante').setup({
        provider = "copilot",
        auto_suggestion_provider = "copilot",
        copilot = {
            model = "claude-3.5-sonnet",
        },
        behavior = {
            auto_set_keymaps = true,
        },
        mappings = {
            ask = "<leader>ca",
            edit = "<leader>ce",
            chat = "<leader>cc",
        },
    })
end

return {
    setup = setup
}
