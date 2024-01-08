local M = {}

function M.config()
    -- "gc" to comment visual regions/lines
    return {
        'numToStr/Comment.nvim',
        opts = { ignore = '^$' }
    }
end

return M
