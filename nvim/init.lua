-- Load general config
require("config.option")

-- Load general keymap config
require("config.keymap")

-- Load lazy.nvim for plugin management
require("config.lazy")

-- Enable LSPs on /lsp/*
local configs = {}

for _, v in ipairs(vim.api.nvim_get_runtime_file("lsp/*", true)) do
	local name = vim.fn.fnamemodify(v, ":t:r")
	configs[name] = true
end

vim.lsp.enable(vim.tbl_keys(configs))
