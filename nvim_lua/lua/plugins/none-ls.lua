local none_ls = require("null-ls")

none_ls.setup({
    sources = {
        none_ls.builtins.formatting.prettier,
        none_ls.builtins.formatting.ktlint,
        none_ls.builtins.formatting.gofumpt,
        none_ls.builtins.formatting.google_java_format,
    }
})
