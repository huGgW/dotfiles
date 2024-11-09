local snacks = require('snacks')

local setup = function()
    snacks.setup({
        bigfile = { enabled = true },

        quickfile = {
            enabled = true,
        },

        lazygit = {
            configure = true,
        },

        notifier = {
            enabled = true,
            top_down = false,
        },

        statuscolumn = {
            enabled = true, -- ??
        },

        terminal = {
        },

        words = {
            enabled = false,
        },
    })
end

return {
    setup = setup
}
