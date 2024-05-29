local lspconfig = require("lspconfig")

-- gleam lsp setup
lspconfig.gleam.setup{}

-- swift lsp setup
lspconfig.sourcekit.setup{
    cmd = {"/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp"}
}
