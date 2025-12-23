return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			vim.api.nvim_create_autocmd("BufReadPost", {
				callback = function()
					vim.treesitter.start()
				end,
			})

			-- fold using treesitter
			vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
			vim.wo[0][0].foldmethod = 'expr'

			-- indent using treesitter
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependency = { "nvim-treesitter/nvim-treesitter" },
		init = function()
			-- Disable entire built-in ftplugin mappings to avoid conflicts.
			-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
			vim.g.no_plugin_maps = true
		end,
		config = function()
			-- configuration
			require("nvim-treesitter-textobjects").setup {
				select = {
					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,
					-- You can choose the select mode (default is charwise 'v')
					--
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * method: eg 'v' or 'o'
					-- and should return the mode ('v', 'V', or '<c-v>') or a table
					-- mapping query_strings to modes.
					selection_modes = {
						['@parameter.outer'] = 'v', -- charwise
						['@function.outer'] = 'V', -- linewise
						['@class.outer'] = '<c-v>', -- blockwise
					},
					-- If you set this to `true` (default is `false`) then any textobject is
					-- extended to include preceding or succeeding whitespace. Succeeding
					-- whitespace has priority in order to act similarly to eg the built-in
					-- `ap`.
					--
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * selection_mode: eg 'v'
					-- and should return true of false
					include_surrounding_whitespace = false,
				},
			}
		end,
		keys = {
			{
				"am",
				function() require("nvim-treesitter-textobjects.select").select_textobject("@function.outer") end,
				desc = "Select around function",
				mode = { "x", "o" }
			},
			{
				"im",
				function() require("nvim-treesitter-textobjects.select").select_textobject("@function.inner") end,
				desc = "Select inside function",
				mode = { "x", "o" }
			},
			{
				"ac",
				function() require("nvim-treesitter-textobjects.select").select_textobject("@class.outer") end,
				desc = "Select around class",
				mode = { "x", "o" }
			},
			{
				"ic",
				function() require("nvim-treesitter-textobjects.select").select_textobject("@class.inner") end,
				desc = "Select inside class",
				mode = { "x", "o" }
			},
		}
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependency = { "nvim-treesitter/nvim-treesitter" },
	}
}
