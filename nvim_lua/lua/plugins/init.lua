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
	},
	{
		'jay-babu/mason-nvim-dap.nvim',
		config = function()
			require("plugins.mason-nvim-dap")
		end,
	},
	{
		'rcarriga/nvim-dap-ui',
		dependencies = {'mfussenegger/nvim-dap'},
		config = function ()
			require("plugins.dapui")
		end
	},

	-- Lint && Format
	{
		'jose-elias-alvarez/null-ls.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
	},

	-- Error infos
	{
		"folke/trouble.nvim",
		requires = "nvim-tree/nvim-web-devicons",
		config = function()
			require("trouble").setup {
			}
		end
	},

	-- Github Copilot
	{
		"github/copilot.vim",
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
		"glepnir/lspsaga.nvim",
		event = "LspAttach",
		config = function()
			require("lspsaga").setup({})
		end,
		dependencies = {
		  {"nvim-tree/nvim-web-devicons"},
		  --Please make sure you install markdown and markdown_inline parser
		  {"nvim-treesitter/nvim-treesitter"}
		}
	},

	-- C lsp improve
	{
		"p00f/clangd_extensions.nvim",
		config = function()
			require("clangd_extensions").prepare()
		end,
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

	-- Bottom Status Line
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require("lualine").setup()
		end
	},

	-- Tab bar
	{
		'nanozuki/tabby.nvim',
		config = function()
			require('tabby').setup()
		end
	},

	-- Gitsigns
	{
		'lewis6991/gitsigns.nvim',
		config = function()
			require('gitsigns').setup()
		end
	},

	-- Smooooth
	{
		'psliwka/vim-smoothie',
	},

	-- Extra Beauty
	{
		'stevearc/dressing.nvim',
		opts = {},
	},

	-- Rainbow Parenthesis
	{
		'mrjones2014/nvim-ts-rainbow',
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
		config = function()
			require('indent_blankline').setup()
		end
	},

	-- Telescope (fuzzy finder)
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.1',
		dependencies = { 'nvim-lua/plenary.nvim' },
	},

	-- File Tree
	{
		'nvim-tree/nvim-tree.lua',
		config = function()
			require('nvim-tree').setup()
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

	-- Markdown Preview
	{
		'iamcco/markdown-preview.nvim',
		run = function()
			vim.fn['mkdp#util#install']()
		end,
	},

	-------- colorschemes -----------
	'rebelot/kanagawa.nvim',
	{ 'folke/tokyonight.nvim', branch = 'main' },

	-- {
	-- 	'xiyaowong/transparent.nvim',
	-- 	lazy = false,
	-- 	config = function()
	-- 		require('transparent').setup({
	-- 			enable = true,
	-- 			extra_groups = {
	-- 				-- Invert the `Normal` highlight group.
	-- 				-- This is useful when `background=dark`.
	-- 				-- highlight = "Normal",
	-- 				-- invert = true,
	-- 			},
	-- 			exclude = {},
	-- 		})
	-- 	end
	-- },
})
