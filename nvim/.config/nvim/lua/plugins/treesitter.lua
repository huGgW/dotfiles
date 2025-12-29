return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			vim.api.nvim_create_autocmd('FileType', {
				group = vim.api.nvim_create_augroup('treesitter.setup', {}),
				callback = function(args)
					local buf = args.buf
					local filetype = args.match

					-- you need some mechanism to avoid running on buffers that do not
					-- correspond to a language (like oil.nvim buffers), this implementation
					-- checks if a parser exists for the current language
					local language = vim.treesitter.language.get_lang(filetype) or filetype
					if not vim.treesitter.language.add(language) then
						return
					end

					-- make folds without actually folding anything at start
					vim.wo.foldmethod = 'expr'
					vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
					vim.wo.foldenable = false

					-- enable highlight
					vim.treesitter.start(buf, language)
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependency = { "nvim-treesitter/nvim-treesitter" },
	},
	-- TODO: add increment selection plugin if needed
}
