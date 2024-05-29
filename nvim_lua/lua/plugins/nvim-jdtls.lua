function config(opts)
    require("jdtls").start_or_attach({
        on_attach = function(client, bufnr)
            vim.lsp.inlay_hint.enable(true, { bufnr=bufnr })
        end,

        cmd = { 'jdtls' },

        root_dir = vim.fs.dirname(
            vim.fs.find(
                { 'gradlew', '.git', 'mvnw' }, { upward = true }
            )[1]
        ),

        settings = {
            java = {
                inlayHints = {
                    parameterNames = {
                        enabled = "all",
                        exclusions = {},
                    },
                },
            }
        },
    })
end

return {
    config = config,
}
