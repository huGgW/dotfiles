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
    {
        'nanozuki/tabby.nvim',
        config = function()
            vim.o.showtabline = 2

            require('tabby').setup({
                preset = 'active_wins_at_end',
                option = {
                    theme = {
                        fill = 'TabLineFill',       -- tabline background
                        head = 'TabLine',           -- head element highlight
                        current_tab = 'TabLineSel', -- current tab label highlight
                        tab = 'TabLine',            -- other tab label highlight
                        win = 'TabLine',            -- window highlight
                        tail = 'TabLine',           -- tail element highlight
                    },
                    nerdfont = true,                -- whether use nerdfont
                    lualine_theme = nil,            -- lualine theme name
                    buf_name = {
                        mode = 'unique',            -- or 'relative', 'tail', 'shorten'
                    },
                },
            })
        end,
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
                transparent_background = false,
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

            vim.cmd.colorscheme("catppuccin")
        end
    },
    {
        "loctvl842/monokai-pro.nvim",
        priority = 999,
        config = function()
            require("monokai-pro").setup({
                transparent_background = false,

                day_night = {
                    enable = true,
                    day_filter = "light",
                    night_filter = "pro",
                },

                override = function(c)
                    local hp = require("monokai-pro.color_helper")
                    local common_fg = hp.lighten(c.sideBar.foreground, 30)
                    return {
                        SnacksPicker = { bg = c.editor.background, fg = common_fg },
                        SnacksPickerBorder = { bg = c.editor.background, fg = c.tab.unfocusedActiveBorder },
                        SnacksPickerTree = { fg = c.editorLineNumber.foreground },
                        SnacksPickerDirectory = { fg = c.editorLineNumber.foreground },
                        NonText = { fg = c.base.dimmed3 }, -- not sure if this should be broken into all hl groups importing NonText
                    }
                end,
            })
        end,
    },
}
