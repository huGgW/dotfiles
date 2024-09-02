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
		event = "BufEnter",
		config = function()
			require('plugins.java').setup()
		end,
	},

	-- Mason (LSP installer)
	{
		'williamboman/mason.nvim',
		event = "BufEnter",
		build = ":MasonUpdate", -- updates registry contents
		config = function()
			require("mason").setup()
		end
	},
	{
		'williamboman/mason-lspconfig.nvim',
		event = "BufEnter",
		config = function()
			require("plugins.mason-lspconfig")
		end
	},

	-- Lsp Config
	{
		'neovim/nvim-lspconfig',
		event = "BufRead",
		config = function()
			require("plugins.lspconfig")
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
		cmd = { "DapToggleBreakPoint", "DapContinue" },
		dependencies = { 'mfussenegger/nvim-dap' },
		config = function()
			require("plugins.dapui")
		end
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
		'nvimtools/none-ls.nvim',
		event = "BufRead",
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			require("plugins.none-ls")
		end
	},

	-- snippets
	{
		"rafamadriz/friendly-snippets",
		event = "BufRead",
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

	-- Copilot chat
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		cmd = {
			"CopilotChat",
			"CopilotChatToggle",
			"CopilotChatFix",
			"CopilotChatExplain",
			"CopilotChatCommit",
		},
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
		event = "InsertEnter",
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
		'linux-cultist/venv-selector.nvim',
		dependencies = {
			'neovim/nvim-lspconfig',
			'nvim-telescope/telescope.nvim',
			'mfussenegger/nvim-dap-python'
		},
		opts = {
			name = 'venv',
		},
		event = 'VeryLazy',
	},
	-- Kotlin
	{
		"udalov/kotlin-vim",
		ft = "kotlin"
	},
	-- Typescript
	{
		"pmizio/typescript-tools.nvim",
		ft = { "javascript", "typescript" },
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
	-- nvim lua lsp Improve
	{
		'folke/neodev.nvim',
		ft = "lua",
		event = "LspAttach",
		opts = {}
	},
	-- json/yaml common schemas
	{
		"b0o/schemastore.nvim",
		event = "BufRead",
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

	-- Smooooth
	{
		'psliwka/vim-smoothie',
		cond = not vim.g.neovide,
	},

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
		event = "LspAttach",
		config = function()
			require("plugins.lspkind")
		end
	},

	-- Dashboard
	-- {
	-- 	'nvimdev/dashboard-nvim',
	-- 	event = 'VimEnter',
	-- 	config = function()
	-- 		require('dashboard').setup {
	-- 		}
	-- 	end,
	-- 	dependencies = { { 'nvim-tree/nvim-web-devicons' } }
	-- },

	-- Rainbow Parenthesis
	{
		'HiPhish/rainbow-delimiters.nvim',
		event = "BufRead",
		config = function()
			require('rainbow-delimiters.setup').setup()
		end
	},

	-- TODO
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

	-- Toggle Term
	{
		'akinsho/toggleterm.nvim',
		key = "<C-`>",
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

	-- Markdown render
	{
		'MeanderingProgrammer/markdown.nvim',
		name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
		ft = "markdown",
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		config = function()
			require('render-markdown').setup({})
		end,
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
			"rcarriga/nvim-notify",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			-- configuration goes here
		},
	},
})
