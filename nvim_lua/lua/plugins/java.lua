local java = require('java')

local function setup()
    java.setup({})
end

return {
    setup = setup
}
