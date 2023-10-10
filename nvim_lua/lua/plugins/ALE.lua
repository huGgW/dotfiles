-- Config fixers for ALE
vim.g.ale_fixers = {
    javascript = {'prettier', 'eslint'},
    typescript = {'prettier', 'eslint'},
    typescriptreact = {'prettier', 'eslint'},
    html = {'prettier'},
    css = {'prettier'},

    python = {'black'},
    kotlin = {'ktlint'},
}

-- Auto format on save
vim.g.ale_fix_on_save = 1
