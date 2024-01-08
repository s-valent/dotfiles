local M = {}

function M.config()
    return 'navarasu/onedark.nvim'
end

function M.setup()
    local c = {
        black = '#000000',
        bg0 = '#2d2d2d',
        bg1 = '#343434',
        bg2 = '#444444',
        bg3 = '#545454',
        bg_d = '#282828',
        bg_blue = '#6699cc',
        bg_yellow = '#f0d197',
        fg = '#cccccc',
        purple = '#c594c5',
        green = '#99c794',
        orange = '#f99157',
        blue = '#6699cc',
        yellow = '#fac863',
        cyan = '#5fb3b3',
        red = '#e15a60',
        grey = '#768390',
        light_grey = '#a0a0a0',
        dark_cyan = '#456a6a',
        dark_red = '#7d3b3b',
        dark_yellow = '#875a3b',
        dark_purple = '#715974',
        diff_add = '#99c79485',
        diff_delete = '#6c3234',
        diff_change = '#323e51',
        diff_text = '#3b4e68',
        bright_orange = '#ff8800',
    }
    require('onedark').setup({
        colors = c,
        highlights = {
            MatchParen = { bg = c.grey, fg = c.bg0 },
            ['@constructor'] = { fg = c.blue, fmt = 'none' },
            ["@property"] = { fg = c.fg },
        }
      })
    vim.cmd.colorscheme('onedark')
    vim.cmd.hi({ 'CursorLine', 'cterm=none', 'ctermbg=237', 'ctermfg=white' })
end

return M
