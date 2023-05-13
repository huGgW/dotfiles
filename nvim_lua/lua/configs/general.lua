local command = vim.api.nvim_command

-- disable netrw (instead use nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- Set Syntax on
command('syntax on')

-- Set number as relative
command('set number relativenumber')

-- Set cursorline
command('hi CursorLine   cterm=NONE ctermbg=0')
command('set cursorline')

-- Set vertical rulers
command('set colorcolumn=80,120')

-- Set indentation as 4 in default...
command('set tabstop=4')
command('set softtabstop=4')
command('set expandtab')
command('set shiftwidth=4')
command('set autoindent')
command('set copyindent')
command('set smartindent')
