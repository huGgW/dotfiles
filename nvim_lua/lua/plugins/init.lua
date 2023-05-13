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
			require("nvim-treesitter.configs").setup({})
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
		'rcarriga/nvim-dap-ui',
		dependencies = {'mfussenegger/nvim-dap'},
	},

	-- Lint && Format
	{
		'jose-elias-alvarez/null-ls.nvim',
		dependencies = {'nvim-lua/plenary.nvim'},
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

	-- Auto Surround
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

	-- Smooooth
	{
		'karb94/neoscroll.nvim',
		config = function()
			require('neoscroll').setup()
		end,
	},

	-- Extra Beauty
	{
		'stevearc/dressing.nvim',
		opts = {},
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
		dependencies = {'nvim-lua/plenary.nvim'},
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

	-- VSCode like command palette
	{
		'mrjones2014/legendary.nvim',
	},



	-------- colorschemes -----------
	'rebelot/kanagawa.nvim',
	{'folke/tokyonight.nvim', branch='main'},
})
