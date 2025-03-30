-- enable virtual text, virtual line for diagnostics
vim.diagnostic.config({
    virtual_text = true,
    virtual_line = true,
})

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- set syntax on
vim.api.nvim_command("syntax on")

-- set number
vim.api.nvim_command("set number")
