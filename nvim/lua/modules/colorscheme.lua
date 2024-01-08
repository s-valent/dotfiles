local M = {}

function M.config()
    return 'navarasu/onedark.nvim'
end

function M.setup()
    require('onedark').setup({
        colors = {
          bright_orange = "#ff8800",
        },
      })
end

return M
