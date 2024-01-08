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
        transparent = true,
        code_style = {
            comments = 'none',
            keywords = 'none',
            functions = 'none',
            strings = 'none',
            variables = 'none'
        },
        colors = c,
        highlights = {
            MatchParen = { bg = c.grey, fg = c.bg0 },
            ['@attribute'] = { fg = c.fg },
            ['@type'] = { fg = c.cyan },
            ['@constructor'] = { fg = c.blue },
            ['@constant'] = { fg = c.yellow },
            ['@constant.builtin'] = { fg = c.yellow },
            ['@boolean'] = { fg = c.yellow },
            ['@number'] = { fg = c.yellow },
            ['@number.float'] = { fg = c.yellow },
            ['@string'] = { fg = c.green },
            ['@string.regexp'] = { fg = c.orange },
            ['@string.special'] = { fg = c.orange },
            ['@comment'] = { fg = c.light_grey },
            ['@variable'] = { fg = c.fg },
            ['@variable.builtin'] = { fg = c.red },
            ['@variable.parameter'] = { fg = c.orange },
            ['@label'] = { fg = c.yellow },
            ['@punctuation'] = { fg = c.light_grey },
            ['@keyword'] = { fg = c.purple },
            ['@operator'] = { fg = c.light_grey },
            ['@function'] = { fg = c.blue },
            ['@function.method.call'] = { fg = c.blue },
            ['@tag'] = { fg = c.red },
            ['@namespace'] = { fg = c.fg },
        }
      })
    vim.cmd.colorscheme('onedark')
    vim.cmd.hi({ 'CursorLine', 'cterm=none', 'ctermbg=237', 'ctermfg=white' })
end

return M
