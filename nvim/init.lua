vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

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
