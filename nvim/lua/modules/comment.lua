local M = {}

function M.config()
    -- "gc" to comment visual regions/lines
    return {
        'numToStr/Comment.nvim',
        opts = { ignore = '^$' }
    }
end

function M.setup()
    vim.api.nvim_set_keymap('n', 'gc', 'Vgc', {})
end

return M
