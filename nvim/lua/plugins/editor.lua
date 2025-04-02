return {
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
        "lewis6991/gitsigns.nvim",
        event = "BufRead",
        config = function()
            require("gitsigns").setup()
        end,
    },
    {
        'christoomey/vim-tmux-navigator',
    },
}
