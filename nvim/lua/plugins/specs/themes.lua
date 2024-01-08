return {
  {
    'navarasu/onedark.nvim',
    config = function(_, opts)
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
      -- vim.cmd.colorscheme('onedark')
      -- vim.cmd.hi({ 'CursorLine', 'cterm=none', 'ctermbg=237', 'ctermfg=white' })
    end
  },
  {
    'norcalli/nvim-colorizer.lua',
    config = function(_, opts)
      require('colorizer').setup({}, {
        RRGGBBAA = true,
        names = false,
      })
    end
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup({
        flavor = 'mocha',
        no_italic = true,
        -- no_bold = true,
        color_overrides = {
          mocha = {
            rosewater = '#fbd1a9',
            flamingo = '#768390',
            pink = '#f99157',
            mauve = '#c594c5',
            red = '#e15a60',
            maroon = '#f2947b',
            peach = '#fac863',
            yellow = '#5fb3b3',
            green = '#99c794',
            teal = '#5fb3b3',
            sky = '#768390',
            sapphire = '#ef7c65',
            blue = '#6699cc',
            lavender = '#cccccc',
            text = '#cccccc',
            subtext1 = '#babbbb',
            subtext0 = '#a9a8a9',
            overlay2 = '#979797',
            overlay1 = '#858685',
            overlay0 = '#747374',
            surface2 = '#626262',
            surface1 = '#505150',
            surface0 = '#3f3e3e',
            base = '#2d2d2d',
            mantle = '#262524',
            crust = '#1f1f1d',
          }
        },
        custom_highlights = function(colors)
        return {
          [ '@function.builtin' ] = { fg = colors.blue },
        }
    end
      })
      vim.cmd.colorscheme('catppuccin')
    end
  },
  {
    'vague2k/vague.nvim',
    config = function()
      require('vague').setup({
        colors = {
          bg = "#1d1f20",
        },
      })
      -- vim.cmd.colorscheme('vague')
    end
  },
}
