return {
    {
        "petertriho/nvim-scrollbar",
        dependencies = {
            "lewis6991/gitsigns.nvim",
            "kevinhwang91/nvim-hlslens",
        },
        event = "BufRead",
        config = function()
            require("scrollbar").setup({
            })
        end
    },
    {
        "folke/noice.nvim",
        -- event = "VeryLazy",
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
        },
        opts = {
            presets = {
                bottom_search = false,        -- use a classic bottom cmdline for search
                command_palette = true,       -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false,           -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = true,        -- add a border to hover docs and signature help
            },
        }
    },

    -- colorschemes
    {
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
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 999,
        config = function()
            require("catppuccin").setup({
                flavour = "auto", -- latte, frappe, macchiato, mocha
                background = {    -- :h background
                    light = "latte",
                    dark = "mocha",
                },
                transparent_background = true,
                term_colors = true,
                default_integrations = true,
                integrations = {
                    gitsigns = true,
                    mini = { enabled = true },
                    noice = true,
                    nvim_surround = true,
                    rainbow_delimiters = true,
                    snacks = { enabled = true },
                    treesitter = true,
                    which_key = true,
                },
            })

            -- setup must be called before loading
            vim.cmd.colorscheme "catppuccin"
        end
    },
}
