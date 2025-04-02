-- Set leader key as space bar
vim.g.mapleader = " "
vim.g.localmapleader = " "

-- Set clipboard shortcuts
vim.api.nvim_set_keymap("v", "<leader>y", '"+y', { desc = "yank" })
vim.api.nvim_set_keymap("v", "<leader>d", '"+d', { desc = "delete & yank" })
vim.api.nvim_set_keymap("n", "<leader>yy", '"+yy', { desc = "yank line" })
vim.api.nvim_set_keymap("n", "<leader>p", '"+p', { desc = "paste" })
vim.api.nvim_set_keymap("n", "<leader>P", '"+P', { desc = "paset line" })
vim.api.nvim_set_keymap("v", "<leader>p", '"+p', { desc = "paste" })
vim.api.nvim_set_keymap("v", "<leader>P", '"+P', { desc = "paset line" })
