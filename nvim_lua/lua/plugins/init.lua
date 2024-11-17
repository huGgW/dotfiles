-- Initialize lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- TreeSitter (Syntax Highlighter)
    {
        'nvim-treesitter/nvim-treesitter',
        event = "BufRead",
        build = ":TSUpdate",
        config = function()
            require("plugins.nvim-treesitter")
        end
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        event = "BufRead",
        cond = not vim.g.neovide,
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
    },
    {
        'windwp/nvim-ts-autotag',
        event = "BufRead",
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
    },

    -- Java LSP specific (should be come before mason, lspconfig)
    {
        'nvim-java/nvim-java',
        ft = "java",
        config = function()
            require('plugins.java').setup()
        end,
    },

    -- Mason (LSP installer)
    {
        'williamboman/mason.nvim',
        event = "BufRead",
        build = ":MasonUpdate", -- updates registry contents
        opts = {},
    },
    {
        'williamboman/mason-lspconfig.nvim',
        event = "VeryLazy",
        config = function()
            require("plugins.mason-lspconfig")
        end
    },

    -- Lsp Config
    {
        'neovim/nvim-lspconfig',
        -- dependencies = { 'saghen/blink.cmp' },
        event = "BufRead",
        config = function()
            require("plugins.lspconfig").setup()
        end,
    },

    -- DAP (Debug)
    {
        'mfussenegger/nvim-dap',
        cmd = { "DapToggleBreakPoint", "DapContinue" },
        dependencies = { 'nvim-neotest/nvim-nio' },
        config = function()
            require('plugins.nvim-dap')
        end,
    },
    {
        'jay-babu/mason-nvim-dap.nvim',
        cmd = { "DapToggleBreakPoint", "DapContinue" },
        config = function()
            require("plugins.mason-nvim-dap")
        end,
    },
    {
        'rcarriga/nvim-dap-ui',
        dependencies = { 'mfussenegger/nvim-dap' },
        event = 'VeryLazy',
        config = function()
            require("plugins.dapui")
        end,
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        cmd = { "DapToggleBreakPoint", "DapContinue" },
        config = function()
            require("nvim-dap-virtual-text").setup({
            })
        end
    },

    -- Inlay Hints
    {
        "MysticalDevil/inlay-hints.nvim",
        event = "LspAttach",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            require("inlay-hints").setup()
        end
    },

    -- Lint && Format
    {
        'mfussenegger/nvim-lint',
        event = "LspAttach",

    },
    {
        'stevearc/conform.nvim',
        opts = {},
        event = "LspAttach",
        config = function()
            require("plugins.conform").setup()
        end,
    },

    -- tests
    {
        "nvim-neotest/neotest",
        cmd = "Neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",

            "nvim-neotest/neotest-python",
            "nvim-neotest/neotest-go"
        },
        config = function()
            require("plugins.neotest")
        end,
    },

    -- task handling
    {
        'stevearc/overseer.nvim',
        opts = {},
        event = "VeryLazy",
        config = function()
            require('overseer').setup()
        end,
    },

    -- snippets
    {
        "rafamadriz/friendly-snippets",
        event = "BufRead",
    },

    -- illuminate
    {
        'RRethy/vim-illuminate',
        event = "BufRead",
        config = function()
            require("illuminate").configure({
                providers = {
                    'treesitter',
                    'lsp',
                    'regex'
                }
            })
        end
    },

    -- Error infos
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("trouble").setup {
            }
        end
    },

    -- Outline
    {
        'stevearc/aerial.nvim',
        cmd = {
            "AerialToggle",
        },
        opts = {},
        -- Optional dependencies
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            require('plugins.aerial')
        end
    },

    -- Github Copilot
    {
        'zbirenbaum/copilot.lua',
        event = "InsertEnter",
        config = function()
            require('plugins.copilot')
        end,
    },

    -- AI assistance like Cursor IDE
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        -- lazy = false,
        version = false, -- set this if you want to always pull the latest change
        build = "make",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            -- "stevearc/dressing.nvim", -- NOTE: Reenable this plugin when avante not works properly
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
            "zbirenbaum/copilot.lua",      -- for providers='copilot'
            "HakonHarnes/img-clip.nvim",
            'MeanderingProgrammer/render-markdown.nvim',
        },
        config = function()
            require("plugins.avante").setup()
        end,
    },

    -- Auto Complete
    {
        "iguanacucumber/magazine.nvim",
        name = "nvim-cmp",
        event = "BufRead",
        config = function()
            require('plugins.nvim-cmp').setup()
        end,
    },

    --* the sources *--
    { "iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp", opts = {} },
    { "iguanacucumber/mag-nvim-lua", name = "cmp-nvim-lua" },
    { "iguanacucumber/mag-buffer",   name = "cmp-buffer" },
    { "iguanacucumber/mag-cmdline",  name = "cmp-cmdline" },
    { "hrsh7th/cmp-vsnip" },
    { "hrsh7th/vim-vsnip" },
    "https://codeberg.org/FelipeLema/cmp-async-path", -- not by me, but better than cmp-path
    -- {
    --     'saghen/blink.cmp',
    --     lazy = false, -- lazy loading handled internally
    --
    --     -- optional: provides snippets for the snippet source
    --     dependencies = 'rafamadriz/friendly-snippets',
    --
    --     -- use a release tag to download pre-built binaries
    --     version = 'v0.*',
    --
    --     -- allows extending the enabled_providers array elsewhere in your config
    --     -- without having to redefining it
    --     opts_extend = { "sources.completion.enabled_providers" },
    --
    --     config = function()
    --         require('plugins.blink-cmp').setup()
    --     end
    -- },

    -- Improve LSP
    {
        "nvimdev/lspsaga.nvim",
        event = "LspAttach",
        config = function()
            require("plugins.lspsaga")
        end,
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
            --Please make sure you install markdown and markdown_inline parser
            { "nvim-treesitter/nvim-treesitter" }
        }
    },

    --- Language-specific LSP support
    -- Go DAP improvement
    {
        'leoluz/nvim-dap-go',
        ft = "go",
        config = function()
            require("dap-go").setup()
        end
    },
    -- Python venv selector
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "mfussenegger/nvim-dap", "mfussenegger/nvim-dap-python", --optional
            { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
        },
        ft = "python",
        branch = "regexp", -- This is the regexp branch, use this for the new version
        config = function()
            require("venv-selector").setup()
        end,
    },
    -- Kotlin
    {
        "udalov/kotlin-vim",
        ft = "kotlin"
    },
    -- Typescript
    {
        "pmizio/typescript-tools.nvim",
        ft = {
            "javascript",
            "typescript",
            "typescriptreact",
            "javascriptreact",
            "typescript.tsx",
            "javascript.tsx",
        },
        event = "LspAttach",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {},
    },
    -- C / C++
    {
        "p00f/clangd_extensions.nvim",
        ft = { "c", "cpp" },
        event = "LspAttach",
    },
    -- rust
    {
        'saecki/crates.nvim',
        tag = 'stable',
        ft = "rust",
        event = "LspAttach",
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('crates').setup()
        end,
    },
    {
        'mrcjkb/rustaceanvim',
        version = '^5', -- Recommended
        lazy = false,   -- This plugin is already lazy
    },
    -- lsp improvement for neovim config, develop
    {
        'folke/lazydev.nvim',
        ft = "lua",
        event = "LspAttach",
        opts = {},
    },
    -- json/yaml common schemas
    {
        "b0o/schemastore.nvim",
        ft = { "json", "yaml" },
        event = "BufRead",
    },

    -- QoL bundle plugins
    {
        'folke/snacks.nvim',
        -- priority = 1000,
        event = 'VeryLazy',
        config = function()
            require('plugins.snacks').setup()
        end
    },

    -- Surround
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },

    -- Auto Pair
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("plugins.nvim-autopairs")
        end
    },

    -- Easy Motion
    {
        "easymotion/vim-easymotion",
        event = "BufRead",
    },

    -- Bottom Status Line
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require("plugins.lualine")
        end
    },

    -- Tab bar
    {
        'akinsho/bufferline.nvim',
        -- version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
            require("plugins.bufferline")
        end
    },

    -- Gitsigns
    {
        'lewis6991/gitsigns.nvim',
        event = "BufRead",
        config = function()
            require('gitsigns').setup()
        end
    },

    -- Git Blame
    {
        'f-person/git-blame.nvim',
        event = "BufRead",
    },

    -- DiffView
    {
        "sindrets/diffview.nvim",
        cmd = {
            "DiffviewOpen",
        },
    },

    -- github issue & pull requests
    {
        'pwntester/octo.nvim',
        cmd = "Octo",
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        config = function()
            require("plugins.octo")
        end,
    },

    -- Smooth
    {
        'karb94/neoscroll.nvim',
        event = "BufRead",
        cond = not vim.g.neovide,
        config = function()
            require('plugins.neoscroll')
        end
    },

    -- Extra Beauty
    -- {
    --     "folke/noice.nvim",
    --     event = "VeryLazy",
    --     opts = {
    --         -- add any options here
    --     },
    --     dependencies = {
    --         -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    --         "MunifTanjim/nui.nvim",
    --         -- OPTIONAL:
    --         --   `nvim-notify` is only needed, if you want to use the notification view.
    --         --   If not available, we use `mini` as the fallback
    --         -- "rcarriga/nvim-notify",
    --         -- 'echasnovski/mini.nvim',
    --     },
    --     config = function()
    --         require("plugins.noice")
    --     end
    -- },
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        config = function()
            require("plugins.notify")
        end
    },

    -- LSP load notify
    {
        "j-hui/fidget.nvim",
        opts = {
            ignore = {
                "jdtls",
            }
        },
        event = "LspAttach",
    },

    -- Scrollbar
    {
        "dstein64/nvim-scrollview",
        cond = not vim.g.neovide,
    },

    -- vscode icon on auto-complete
    {
        "onsails/lspkind-nvim",
        event = "LspAttach",
        config = function()
            require("plugins.lspkind")
        end
    },

    -- Dashboard
    {
        'nvimdev/dashboard-nvim',
        event = 'VimEnter',
        config = function()
            require('plugins.dashboard').setup()
        end,
        dependencies = { { 'nvim-tree/nvim-web-devicons' } }
    },

    -- Rainbow Parenthesis
    {
        'HiPhish/rainbow-delimiters.nvim',
        event = "BufRead",
        config = function()
            require('rainbow-delimiters.setup').setup()
        end
    },

    -- comment improvement
    {
        "folke/ts-comments.nvim",
        opts = {},
        event = "VeryLazy",
        enabled = vim.fn.has("nvim-0.10.0") == 1,
    },

    {
        "folke/todo-comments.nvim",
        event = "BufRead",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },

    -- Indent
    {
        'nmac427/guess-indent.nvim',
        cmd = "GuessIndent",
        config = function()
            require('guess-indent').setup()
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufRead",
        main = "ibl",
        opts = {},
        config = function()
            require('ibl').setup()
        end
    },

    -- Fold
    {
        "kevinhwang91/nvim-ufo",
        event = "BufRead",
        dependencies = { "kevinhwang91/promise-async" },
    },

    -- Telescope (fuzzy finder)
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.3',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        config = function()
            require('telescope').load_extension('lsp_handlers')
        end
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        dependencies = {
            'nvim-telescope/telescope.nvim',
        },
    },
    {
        'gbrlsnchs/telescope-lsp-handlers.nvim',
        dependencies = { 'nvim-telescope/telescope.nvim' },
    },

    -- File Tree
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        cmd = "Neotree",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        },
        config = require('plugins.neotree').config,
    },

    -- Oil.nvim (file manage like buffer)
    {
        'stevearc/oil.nvim',
        cmd = "Oil",
        opts = {},
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        config = function()
            require('oil').setup()
        end
    },

    -- Scratch pad
    {
        "LintaoAmons/scratch.nvim",
        event = "VeryLazy",
    },

    -- Tmux + Vim
    {
        'christoomey/vim-tmux-navigator',
    },

    -- Vim Multiple Cursor
    {
        'mg979/vim-visual-multi',
        event = "BufRead",
        branch = 'master',
    },

    -- Popup key hints
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            })
        end,
    },

    -- Search keymaps
    {
        "tris203/hawtkeys.nvim",
        cmd = { "Hawtkeys" },
        dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
        config = {},
    },

    -- Markdown Preview
    {
        'iamcco/markdown-preview.nvim',
        cmd = {
            'MarkdownPreview',
            'MarkdownPreviewStop',
            'MarkdownPreviewToggle',
        },
        config = function()
            vim.fn['mkdp#util#install']()
        end,
    },

    -- Markdown render
    {
        'MeanderingProgrammer/markdown.nvim',
        name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
        ft = { "markdown", "Avante", "octo" },
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            require('render-markdown').setup({
                file_types = { "markdown", "Avante", "octo" },
            })
        end,
    },

    -- Image paste
    {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
            -- recommended settings
            default = {
                embed_image_as_base64 = false,
                prompt_for_file_name = false,
                drag_and_drop = {
                    insert_mode = true,
                },
                -- required for Windows users
                use_absolute_path = true,
            },
        },
    },

    -- Colorrize
    {
        'NvChad/nvim-colorizer.lua',
        config = function()
            require('colorizer').setup()
        end
    },

    -------- colorschemes -----------
    -- Auto dark/light for macOS
    {
        'cormacrelf/dark-notify',
        priority = 1000,
        config = function()
            require('dark_notify').run()
        end
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 999,
        config = function()
            require('plugins.catppuccin')
        end,
    },
    {
        "folke/tokyonight.nvim",
        priority = 999,
        config = function()
            require('plugins.tokyonight')
        end,
    },
    {
        "EdenEast/nightfox.nvim",
        priority = 999,
        config = function()
            require('plugins.nightfox')
        end,
    },
    {
        "sainnhe/everforest",
        priority = 999,
    },
    {
        'Mofiqul/dracula.nvim',
        priority = 999,
    },
    {
        "savq/melange-nvim",
        priority = 999,
    },
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require('plugins.gruvbox').setup()
        end,
    },


    -------- extra ---------------
    {
        "kawre/leetcode.nvim",
        build = ":TSUpdate html",
        cmd = "Leet",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim", -- required by telescope
            "MunifTanjim/nui.nvim",

            -- optional
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
            -- "rcarriga/nvim-notify",
        },
        opts = {
            -- configuration goes here
        },
    },
})
