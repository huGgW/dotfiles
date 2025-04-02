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
			{
				"<leader>lg",
				function()
					Snacks.lazygit()
				end,
				desc = "LazyGit",
			},
			{
				"<C-`>",
				function()
					Snacks.terminal()
				end,
				mode = { "n", "t" },
				desc = "Terminal",
			},
			{
				"<leader>te",
				function()
					Snacks.explorer()
				end,
				desc = "Explorer",
			},

			-- pickers
			{
				"<leader>fo",
				function()
					Snacks.picker.files()
				end,
				desc = "Find Files",
			},
			{
				"<leader>fs",
				function()
					Snacks.picker.grep()
				end,
				desc = "Grep",
			},
			{
				"<leader>fb",
				function()
					Snacks.picker.buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>fp",
				function()
					Snacks.picker.commands()
				end,
				desc = "Commands",
			},
			{
				"<leader>g?",
				function()
					Snacks.picker.keymaps()
				end,
				desc = "Keymaps",
			},

			-- LSP-related picker
			{
				"gd",
				function()
					Snacks.picker.lsp_definitions()
				end,
				desc = "Goto Definition",
			},
			{
				"gD",
				function()
					Snacks.picker.lsp_declarations()
				end,
				desc = "Goto Declaration",
			},
			{
				"gr",
				function()
					Snacks.picker.lsp_references()
				end,
				nowait = true,
				desc = "References",
			},
			{
				"gI",
				function()
					Snacks.picker.lsp_implementations()
				end,
				desc = "Goto Implementation",
			},
			{
				"gy",
				function()
					Snacks.picker.lsp_type_definitions()
				end,
				desc = "Goto T[y]pe Definition",
			},
			{
				"<leader>fd",
				function()
					Snacks.picker.lsp_workspace_symbols()
				end,
				desc = "LSP Workspace Symbols",
			},
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
