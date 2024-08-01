local none_ls = require("null-ls")

none_ls.setup({
    sources = {
        none_ls.builtins.formatting.gofumpt,
        none_ls.builtins.formatting.goimports,
    }
})
