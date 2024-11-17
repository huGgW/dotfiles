local conform = require('conform')

local javascript_family_fmt = {
    "biome",
    "prettier",
    stop_after_first = true,
}

local function setup()
    conform.setup({
        formatters_by_ft = {
            go = { "goimports", "gofumpt" },
            python = { "ruff" },
            java = { "google-java-format" },
            kotlin = { "ktlint" },
            sql = { "sql-formatter" },
            yaml = { "yamlfmt" },
            javascript = javascript_family_fmt,
            javascriptreact = javascript_family_fmt,
            typescript = javascript_family_fmt,
            typescriptreact = javascript_family_fmt,
        },

        default_format_opts = {
            lsp_format = "fallback",
        },
    })
end

return {
    setup = setup
}
