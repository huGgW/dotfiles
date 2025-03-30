-- enable virtual text for diagnostics
vim.diagnostic.config({ virtual_text = true })

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- set syntax on
vim.api.nvim_command("syntax on")

-- set number
vim.api.nvim_command("set number")