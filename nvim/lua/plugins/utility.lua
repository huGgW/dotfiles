return {
    {
        "folke/snacks.nvim",
        priority = 998,
        lazy = false,
        opts = {
            -- file utililty
            bigfile = { enabled = true },
            quickfile = { enabled = true },
            -- TODO: config rename if needed

            -- ui utility
            indent = { enabled = true },
            notifier = { enabled = true },
            scroll = { enabled = true },
            statuscolumn = { enabled = true },

            -- image utility
            image = { enabled = true },

            -- git utility
            lazygit = { enabled = true },

            -- search utility
            -- TODO: configure picker

            -- extra utility
            terminal = { enabled = true },
            -- TODO: configure scratch if needed
        },
        keys = {
            { "<leader>lg", function() Snacks.lazygit() end, desc = "LazyGit" },
            { "<leader>tm", function() Snacks.terminal() end, desc = "Terminal" },
        },
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
    },
    {
        'echasnovski/mini.nvim',
        version = false,
    },
}
