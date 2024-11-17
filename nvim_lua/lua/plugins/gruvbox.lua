local function setup()
    require('gruvbox').setup({
        contrast = "hard",
        transparent_mode = false,
        inverse = true,
    })
end

return {
    setup = setup
}
