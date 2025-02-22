vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
vim.g.is_posix = true

vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.cursorline = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.swapfile = false
vim.opt.mousescroll = 'ver:1,hor:1'
vim.opt.fillchars:prepend({ eob = ' ', vert = '┃' })
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkon100"
vim.cmd("exec 'au Filetype * set formatoptions-=cro'")

vim.opt.termguicolors = true
vim.opt.hlsearch = true
vim.g.have_nerd_font = false

-- works well only with which-key
vim.opt.updatetime = 0
vim.opt.timeoutlen = 0

-- comment
vim.keymap.del('n', 'gcc')
vim.keymap.set('n', 'gc', function() vim.cmd.normal('Vgc') end)

-- quicklist jumps
vim.keymap.set('n', '<m-up>', ':cp<cr>')
vim.keymap.set('n', '<m-down>', ':cn<cr>')
