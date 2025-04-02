return {
    {
        "folke/snacks.nvim",
        priority = 998,
        lazy = false,
        opts = {
            -- file utililty
            bigfile = { enabled = true },
            quickfile = { enabled = true },
            explorer = { enabled = true },
            -- TODO: config rename if needed

            -- ui utility
            indent = { enabled = true },
            notifier = { enabled = true },
            statuscolumn = { enabled = true },
            -- scroll = { enabled = true },

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
            { "<leader>te", function() Snacks.explorer() end, desc = "Explorer" },
        },
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
    },
    {
        "echasnovski/mini.nvim",
        version = false,
        config = function()
            -- Text Editing
            require("mini.pairs").setup()

            -- General Workflow

            -- Appearance
            require("mini.animate").setup()
            require("mini.statusline").setup()
            require("mini.tabline").setup()
        end,
    },
}
