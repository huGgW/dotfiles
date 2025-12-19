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
vim.opt.relativenumber = true

-- relative number based on insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    callback = function()
        vim.opt.relativenumber = false
    end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function()
        vim.opt.relativenumber = true
    end,
})

-- relative number based on focus
vim.api.nvim_create_autocmd("FocusLost", {
    pattern = "*",
    callback = function()
        vim.opt.relativenumber = false
    end,
})

vim.api.nvim_create_autocmd("FocusGained", {
    pattern = "*",
    callback = function()
        vim.opt.relativenumber = true
    end,
})

-- Set indentation as 4 in default
vim.api.nvim_command("set tabstop=4")
vim.api.nvim_command("set softtabstop=4")
vim.api.nvim_command("set expandtab")
vim.api.nvim_command("set shiftwidth=4")
vim.api.nvim_command("set autoindent")
vim.api.nvim_command("set copyindent")
vim.api.nvim_command("set smartindent")

-- Set cursorline
vim.api.nvim_command('hi CursorLine   cterm=NONE ctermbg=0')
vim.api.nvim_command('set cursorline')

-- Set vertical rulers
vim.api.nvim_command('set colorcolumn=100')

-- Set auto refresh when gain focus or enter buffer
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
    command = "if mode() != 'c' | checktime | endif",
    pattern = "*",
})

-- Set reading local config file (ex. .nvim.lua)
vim.o.exrc = true
