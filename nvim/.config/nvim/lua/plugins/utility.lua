return {
    {
        "folke/snacks.nvim",
        priority = 998,
        lazy = false,
        config = function()
            local scrollEnable = true
            if vim.g.neovide then
                scrollEnable = false
            end

            ---@class snacks.layout.Box
            local extendedDefaultLayout = {
                box = "horizontal",
                width = 0.95,
                min_width = 120,
                height = 0.95,
                {
                    box = "vertical",
                    border = true,
                    title = "{title} {live} {flags}",
                    { win = "input", height = 1,     border = "bottom" },
                    { win = "list",  border = "none" },
                },
                { win = "preview", title = "{preview}", border = true, width = 0.75 },
            }

            ---@class snacks.layout.Box
            local extendedVerticalLayout = {
                backdrop = false,
                width = 0.95,
                min_width = 80,
                height = 0.95,
                min_height = 30,
                box = "vertical",
                border = true,
                title = "{title} {live} {flags}",
                title_pos = "center",
                { win = "input",   height = 1,          border = "bottom" },
                { win = "list",    border = "none" },
                { win = "preview", title = "{preview}", height = 0.75,    border = "top" },
            }

            require("snacks").setup({
                -- file utililty bigfile = { enabled = true },
                quickfile = { enabled = true },
                -- explorer = { enabled = true },
                -- TODO: config rename if needed

                -- ui utility
                indent = {
                    enabled = true,
                    chunk = {
                        enabled = true,
                    }
                },
                notifier = { enabled = true },
                statuscolumn = { enabled = true },
                scroll = {
                    enabled = scrollEnable,
                    animate = {
                        easing = "outQuad"
                    },
                },
                input = { enabled = true },
                dim = {},

                -- image utility
                image = { enabled = true },

                -- git utility
                lazygit = { enabled = true },

                -- search utility
                picker = {
                    cycle = true,
                    --     layout = {
                    --         -- TODO: make this responsive based on window size
                    --         layout = vim.o.columns >= 120 and extendedDefaultLayout or extendedVerticalLayout,
                    --     },
                    sources = {
                        gh_diff = {
                            layout = {
                                layout = vim.o.columns >= 120 and extendedDefaultLayout or extendedVerticalLayout,
                            },
                        },
                    },
                },

                -- editing utility
                scope = {
                    enabled = true,
                },

                -- extra utility
                terminal = { enabled = true },
                -- TODO: configure scratch if needed

            })

            -- custom commands
            vim.api.nvim_create_user_command("PR", function()
                Snacks.picker.gh_pr()
            end, { desc = "GitHub Pull Requests" })

            vim.api.nvim_create_user_command("Dim", function()
                if (Snacks.dim.enabled) then
                    Snacks.dim.disable()
                else
                    Snacks.dim.enable()
                end
            end, { desc = "Toggle dim" })

            -- trigger some defaults
            Snacks.dim.enable()
        end,
        keys = {
            { "<leader>lg", function() Snacks.lazygit() end,                desc = "LazyGit" },
            { "<C-`>",      function() Snacks.terminal() end,               mode = { "n", "t" },     desc = "Terminal" },
            -- { "<leader>te", function() Snacks.explorer() end,                     desc = "Explorer" },

            -- pickers
            { "<leader>fo", function() Snacks.picker.files() end,           desc = "Find Files" },
            { "<leader>fs", function() Snacks.picker.grep() end,            desc = "Grep" },
            { "<leader>fb", function() Snacks.picker.buffers() end,         desc = "Buffers" },
            { "<leader>fp", function() Snacks.picker.commands() end,        desc = "Commands" },
            { "<leader>g?", function() Snacks.picker.keymaps() end,         desc = "Keymaps" },

            -- LSP-related picker
            { "gd",         function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
            {
                "gpd",
                function()
                    -- vsplit and move to that window
                    vim.api.nvim_open_win(0, true, { split = "right" })

                    -- call lsp definition picker
                    Snacks.picker.lsp_definitions()
                end,
                desc = "(Vertically) Split And Goto Definition"
            },
            {
                "gvd",
                function()
                    -- vsplit and move to that window
                    vim.api.nvim_open_win(0, true, { split = "right" })

                    -- call lsp definition picker
                    Snacks.picker.lsp_definitions()
                end,
                desc = "Vertically Split And Goto Definition"
            },
            {
                "gsd",
                function()
                    -- ssplit and move to that window
                    vim.api.nvim_open_win(0, true, { split = "below" })

                    -- call lsp definition picker
                    Snacks.picker.lsp_definitions()
                end,
                desc = "Horizontally Split And Goto Definition"
            },
            { "gD",          function() Snacks.picker.lsp_declarations() end,      desc = "Goto Declaration" },
            { "gr",          function() Snacks.picker.lsp_references() end,        nowait = true,                  desc = "References" },
            { "gI",          function() Snacks.picker.lsp_implementations() end,   desc = "Goto Implementation" },
            { "gy",          function() Snacks.picker.lsp_type_definitions() end,  desc = "Goto T[y]pe Definition" },
            { "<leader>fd",  function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
            { "<leader>o",   function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },

            -- Git-related picker
            { "<leader>ghp", function() Snacks.picker.gh_pr() end,                 desc = "Github Pull Requests" },
        },
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
    },
    {
        "nvim-mini/mini.nvim",
        version = false,
        config = function()
            -- Text Editing
            require("mini.pairs").setup()

            -- General Workflow
            require("mini.jump2d").setup()

            -- Appearance
            require("mini.statusline").setup()
            require("mini.trailspace").setup()
        end,
    },
}
