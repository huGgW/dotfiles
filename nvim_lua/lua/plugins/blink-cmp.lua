local function setup()
    require('blink.cmp').setup({
        -- 'default' for mappings similar to built-in completion
        -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
        -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
        -- see the "default configuration" section below for full documentation on how to define
        -- your own keymap.
        keymap = { preset = 'enter' },

        highlight = {
            -- sets the fallback highlight groups to nvim-cmp's highlight groups
            -- useful for when your theme doesn't support blink.cmp
            -- will be removed in a future release, assuming themes add support
            use_nvim_cmp_as_default = true,
        },

        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',

        accept = {
            -- experimental auto-brackets support
            auto_brackets = { enabled = true }
        },

        trigger = {
            -- experimental signature help support
            -- signature_help = { enabled = true }
        },

        windows = {
            autocomplete = {
                border = 'rounded'
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 50,
            }
        }
    })
end

return {
    setup = setup
}
