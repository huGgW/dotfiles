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
	-- {
	-- 	"nvim-treesitter/nvim-treesitter-textobjects",
	-- 	dependency = { "nvim-treesitter/nvim-treesitter" },
	-- },
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependency = { "nvim-treesitter/nvim-treesitter" },
	}
}
