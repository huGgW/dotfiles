require("no-neck-pain").setup ({
    width = 122,
    autocmds = {
        enableOnVimEnter = true,
        enableOnTabEnter = true,
        reloadOnColorSchemeChange = true,
    },
    integrations = {
        NvimTree = {
            position = "left",
            reopen = true,
        },
        NvimDAPUI = {
            position = "none",
            reopen = true,
        },
    },
})
