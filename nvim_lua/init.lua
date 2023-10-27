require("configs.general")
require("plugins")
require("configs.keymap-common")
require("configs.keymap-plugins")
require("configs.colorscheme")

if vim.g.neovide then
	require("configs.neovide")
end
