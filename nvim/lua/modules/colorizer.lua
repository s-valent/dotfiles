local M = {}

function M.config()
    return 'norcalli/nvim-colorizer.lua'
end

function M.setup()
    require('colorizer').setup({}, {
        RRGGBBAA = true,
        names = false,
    })
end

return M
