local map = vim.api.nvim_set_keymap
local vscode = require("vscode-neovim")

-- For Commentary
map('x', 'gc', '<Plug>VSCodeCommentary', {})
map('n', 'gc', '<Plug>VSCodeCommentary', {})
map('o', 'gc', '<Plug>VSCodeCommentary', {})
map('n', 'gcc', '<Plug>VSCodeCommentaryLine', {})

-- For toggle sidbar
-- map('n', '<Leader>te', vscode.action("workbench.action.toggleSidebarVisibility"), {})
