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
		build = ":TSUpdate",
		config = function()
			require("plugins.nvim-treesitter")
		end
	},
	-- {
	-- 	'nvim-treesitter/nvim-treesitter-context',
	-- 	dependencies = { 'nvim-treesitter/nvim-treesitter' },
	-- },
	{
		'windwp/nvim-ts-autotag',
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
	},

	-- Mason (LSP installer)
	{
		'williamboman/mason.nvim',
		build = ":MasonUpdate", -- updates registry contents
		config = function()
			require("mason").setup()
		end
	},
	{
		'williamboman/mason-lspconfig.nvim',
		config = function()
			require("plugins.mason-lspconfig")
		end
	},

	-- Lsp Config
	{
		'neovim/nvim-lspconfig',
		config = function()
			require("plugins.lspconfig")
		end,
	},

	-- DAP (Debug)
	{
		'mfussenegger/nvim-dap',
		dependencies = { 'nvim-neotest/nvim-nio' },
	},
	{
		'jay-babu/mason-nvim-dap.nvim',
		config = function()
			require("plugins.mason-nvim-dap")
		end,
	},
	{
		'rcarriga/nvim-dap-ui',
		dependencies = { 'mfussenegger/nvim-dap' },
		config = function()
			require("plugins.dapui")
		end
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		config = function()
			require("nvim-dap-virtual-text").setup({
			})
		end
	},

	-- Lint && Format
	{
		'nvimtools/none-ls.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			require("plugins.none-ls")
		end
	},

	-- snippets
	{
		"rafamadriz/friendly-snippets",
	},


	-- illuminate
	{
		'RRethy/vim-illuminate',
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
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("trouble").setup {
			}
		end
	},

	-- Outline
	{
		'stevearc/aerial.nvim',
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

	-- ChatGPT Integration
	-- {
	-- 	"jackMort/ChatGPT.nvim",
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		require("chatgpt").setup()
	-- 	end,
	-- 	dependencies = {
	-- 		"MunifTanjim/nui.nvim",
	-- 		"nvim-lua/plenary.nvim",
	-- 		"folke/trouble.nvim",
	-- 		"nvim-telescope/telescope.nvim"
	-- 	}
	-- },


	-- Copilot chat
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch="canary",
		dependencies = {
			{ "zbirenbaum/copilot.lua" },
			{ "nvim-lua/plenary.nvim" },
		},
		opts = {
		},
	},

	-- Auto Complete
	-- For vsnip users.
	'hrsh7th/cmp-vsnip',
	'hrsh7th/vim-vsnip',
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-path',
	'hrsh7th/cmp-cmdline',
	{
		'hrsh7th/nvim-cmp',
		config = function()
			require("plugins.nvim-cmp")
		end
	},

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
	-- Typescript
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},
	-- C / C++
	{
		"p00f/clangd_extensions.nvim",
	},
	-- -- Java
	-- {
	-- 	"mfussenegger/nvim-jdtls",
	-- },
	-- Kotlin
	{
		"udalov/kotlin-vim",
	},
	-- Rust
	{
		"simrat39/rust-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		-- config = function()
		-- 	require("rust-tools").setup({})
		-- end
	},
	{
		'saecki/crates.nvim',
		tag = 'stable',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			require('crates').setup()
		end,
	},
	-- nvim lua lsp Improve
	{
		'folke/neodev.nvim',
		opts = {}
	},
	-- Go DAP improvement
	{
		'leoluz/nvim-dap-go',
		config = function()
			require("dap-go").setup()
		end
	},
	-- json/yaml common schemas
	{
		"b0o/schemastore.nvim",
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
		config = function()
			require("plugins.nvim-autopairs")
		end
	},

	-- Easy Motion
	{
		"easymotion/vim-easymotion"
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
	-- {
	-- 	'nanozuki/tabby.nvim',
	-- 	config = function()
	-- 		require('tabby').setup()
	-- 	end
	-- },
	{
		'akinsho/bufferline.nvim',
		version = "*",
		dependencies = 'nvim-tree/nvim-web-devicons',
		config = function()
			require("plugins.bufferline")
		end
	},

	-- Gitsigns
	{
		'lewis6991/gitsigns.nvim',
		config = function()
			require('gitsigns').setup()
		end
	},

	-- Lazygit
	{
		"kdheepak/lazygit.nvim",
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("telescope").load_extension("lazygit")
		end,
	},

	-- DiffView
	{
		"sindrets/diffview.nvim",
	},

	-- Smooooth
	{
		'psliwka/vim-smoothie',
		cond = not vim.g.neovide,
	},
	-- {
	-- 	'karb94/neoscroll.nvim',
	-- 	cond = not vim.g.neovide,
	-- 	config = function()
	-- 		require('plugins.neoscroll')
	-- 	end
	-- },

	-- Extra Beauty
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			-- add any options here
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
			-- 'echasnovski/mini.nvim',
		},
		config = function()
			require("plugins.noice")
		end
	},
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
		opts = {},
		config = function()
			require("fidget").setup()
		end
	},

	-- Scrollbar
	{
		"dstein64/nvim-scrollview",
		-- cond = not vim.g.neovide,
	},

	-- vscode icon on auto-complete
	{
		"onsails/lspkind-nvim",
		config = function()
			require("plugins.lspkind")
		end
	},

	-- -- Center the buffer
	-- {
	-- 	"shortcuts/no-neck-pain.nvim",
	-- 	version = "*",
	-- 	config = function()
	-- 		require("plugins.no-neck-pain")
	-- 	end,
	-- },

	-- Dim inactive buffer parts
	{
		"folke/twilight.nvim",
		opts = {
			treesitter = true,
		}
	},

	-- Dashboard
	{
		'nvimdev/dashboard-nvim',
		event = 'VimEnter',
		config = function()
			require('dashboard').setup {
			}
		end,
		dependencies = { { 'nvim-tree/nvim-web-devicons' } }
	},

	-- Rainbow Parenthesis
	{
		'HiPhish/rainbow-delimiters.nvim',
		config = function()
			require('rainbow-delimiters.setup').setup()
		end
	},

	-- TODO
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		}
	},

	-- Comment
	{
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	},

	-- Indent
	{
		'nmac427/guess-indent.nvim',
		config = function()
			require('guess-indent').setup()
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
		config = function()
			require('ibl').setup()
		end
	},

	-- Fold
	{
		"kevinhwang91/nvim-ufo",
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
		'nvim-tree/nvim-tree.lua',
		config = function()
			require('nvim-tree').setup()
		end
	},

	-- Oil.nvim (file manage like buffer)
	{
		'stevearc/oil.nvim',
		opts = {},
		dependencies = {
			'nvim-tree/nvim-web-devicons',
		},
		config = function()
			require('oil').setup()
		end
	},

	-- Toggle Term
	{
		'akinsho/toggleterm.nvim',
		version = "*",
		config = function()
			require("plugins.toggleterm")
		end
	},

	-- Tmux + Vim
	{
		'christoomey/vim-tmux-navigator',
	},

	-- Vim Multiple Cursor
	{
		'mg979/vim-visual-multi',
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
		dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
		config = {},
	},

	-- Markdown Preview
	{
		'iamcco/markdown-preview.nvim',
		config = function()
			vim.fn['mkdp#util#install']()
		end,
	},

	-- Colorrize
	{
		'NvChad/nvim-colorizer.lua',
		config = function()
			require('colorizer').setup()
		end
	},

	-- Auto dark/light for macOS
	{
		'cormacrelf/dark-notify',
		config = function()
			require('dark_notify').run()
		end
	},
	-------- colorschemes -----------
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require('plugins.catppuccin')
		end,
	},


	-------- temporary -----------
	{ 'lark-parser/vim-lark-syntax' }
})
