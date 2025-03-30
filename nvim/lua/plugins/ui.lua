return {
    {
        -- colorschemes
        "rose-pine/neovim",
        name = "rose-pine",
        priority = 999,
        config = function()
            require("rose-pine").setup({
                variant = "auto",
                dark_variant = "moon"
            })
        end,
    },
}
