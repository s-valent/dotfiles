local M = {}

function M.setup()
    vim.g.is_posix = true

    vim.opt.number = true
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.expandtab = true
    vim.opt.cursorline = true
    vim.opt.splitright = true
    vim.opt.splitbelow = true
    vim.opt.swapfile = false
    vim.opt.fillchars:prepend({ eob = ' ', vert = '┃' })
    vim.cmd("exec 'au Filetype * set formatoptions-=cro'")

    vim.opt.updatetime = 200
    vim.opt.timeoutlen = 80

    vim.opt.termguicolors = true
    vim.cmd.colorscheme('habamax')
    vim.cmd.hi({ 'MatchParen', 'cterm=none', 'ctermbg=darkgray', 'ctermfg=white' })
    vim.cmd.hi({ 'VertSplit', 'guibg=none' })
    vim.cmd.hi({ 'LineNr', 'ctermfg=grey' })
    vim.cmd.hi({ 'SignColumn', 'ctermfg=grey' })
    vim.cmd.hi({ 'CursorLine', 'cterm=none', 'ctermbg=237' })
    vim.cmd.hi({ 'CursorLineNr', 'cterm=bold', 'ctermbg=237' })
end

return M
