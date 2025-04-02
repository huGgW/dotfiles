-- Set leader key as space bar
vim.g.mapleader = " "
vim.g.localmapleader = " "

-- Set clipboard shortcuts
vim.api.nvim_set_keymap('v', '<Leader>y', '"+y', {})
vim.api.nvim_set_keymap('v', '<Leader>d', '"+d', {})
vim.api.nvim_set_keymap('n', '<Leader>yy', '"+yy', {})
vim.api.nvim_set_keymap('n', '<Leader>p', '"+p', {})
vim.api.nvim_set_keymap('n', '<Leader>P', '"+P', {})
vim.api.nvim_set_keymap('v', '<Leader>p', '"+p', {})
vim.api.nvim_set_keymap('v', '<Leader>P', '"+P', {})

