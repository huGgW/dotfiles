
-- Set leader key as space bar
vim.g.mapleader = " "
vim.g.localmapleader = " "

local map = vim.api.nvim_set_keymap

-- System Clipboard
map('v', '<Leader>y', '"+y', {})
map('v', '<Leader>d', '"+d', {})
map('n', '<Leader>yy', '"+yy', {})
map('n', '<Leader>p', '"+p', {})
map('n', '<Leader>P', '"+P', {})
map('v', '<Leader>p', '"+p', {})
map('v', '<Leader>P', '"+P', {})

-- scroll to center
-- map('n', '<C-d>', '<C-d>zz', {})
-- map('v', '<C-d>', '<C-d>zz', {})
-- map('n', '<C-u>', '<C-u>zz', {})
-- map('v', '<C-u>', '<C-u>zz', {})
