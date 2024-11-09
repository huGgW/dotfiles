local lspconfig = require("lspconfig")
local function blinkcapabilities()
    return require('blink.cmp').get_lsp_capabilities(nil, true)
end

local function setup()
    -- gleam lsp setup
    lspconfig.gleam.setup {
        capabilities = blinkcapabilities(),
    }

    -- swift lsp setup
    lspconfig.sourcekit.setup {
        capabilities = blinkcapabilities(),
        cmd = {
            "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp"
        }
    }
end

return {
    setup = setup
}
