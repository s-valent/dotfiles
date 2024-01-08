vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.is_posix = true

vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.cursorline = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.swapfile = false
vim.opt.mousescroll = 'ver:1,hor:1'
vim.opt.fillchars:prepend({ eob = ' ', vert = '┃' })
vim.cmd("exec 'au Filetype * set formatoptions-=cro'")

vim.opt.updatetime = 200
vim.opt.timeoutlen = 200
vim.opt.termguicolors = true
vim.opt.hlsearch = true

require('utils')
setup_lazy()

local lazy_setup = {}
local packages = {}

for file in ls_config('modules') do
    local package = require(file)
    packages[#packages + 1] = package
    if package.config then
        lazy_setup[#lazy_setup + 1] = package.config()
    end
end

require('lazy').setup(lazy_setup)
for _, package in pairs(packages) do
    if package.setup then
        package.setup()
    end
end
