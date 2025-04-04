local configs = {
    gopls = {
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        single_file_support = true,
    },

    ts_ls = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
        init_options = {
            hostInfo = "neovim",
        },
        single_file_support = true,
    },

    html = {
        cmd = { "vscode-html-language-server", "--stdio" },
        filetypes = { "html", "templ" },
        init_options = {
            configurationSection = { "html", "css", "javascript" },
            embeddedLanguages = {
                css = true,
                javascript = true,
            },
            provideFormatter = true,
        },
        single_file_support = true,
    },

    lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
    }
}


for lsp, cfg in pairs(configs) do
    vim.lsp.config(lsp, cfg)
end

vim.lsp.enable(vim.tbl_keys(configs))
vim.lsp.inlay_hint.enable()
