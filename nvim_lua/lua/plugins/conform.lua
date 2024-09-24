local conform = require('conform')

local function setup()
    conform.setup({
        formatters_by_ft = {
            go = { "goimports", "gofumpt" },
            python = { "ruff" },
            java = { "google-java-format" },
            kotlin = { "ktlint" },
            sql = { "sql-formatter" },
        }
    })
end

return {
    setup = setup
}
