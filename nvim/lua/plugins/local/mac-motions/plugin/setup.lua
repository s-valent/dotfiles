vim.opt.keymodel = 'startsel'
vim.opt.whichwrap:prepend('<,>,[,]')

vim.cmd([[
nmap <Esc> <cmd>nohlsearch<CR>

nnoremap <up> gk
nnoremap <down> gj
vnoremap <up> gk
vnoremap <down> gj
inoremap <up> <c-o>gk
inoremap <down> <c-o>gj

nnoremap <m-f> e
vnoremap <m-b> b
vnoremap <m-f> e
inoremap <m-b> <c-o>:call search("\\(\\<\\\|^\\).", "bW")<cr>
inoremap <m-f> <left><c-o>:call search(".\\(\\>\\\|$\\)", "W")<cr><right>
cnoremap <m-b> <c-left>
cnoremap <m-f> <c-right>

nnoremap <m-s-left> vwb
nnoremap <m-s-right> ve
vnoremap <m-s-left> b
vnoremap <m-s-right> e
inoremap <m-s-left> <esc>vwb
inoremap <m-s-right> <c-o>ve

nnoremap <expr> <home> col('.') != 1 ? '0' : '<left>g$'
nnoremap <expr> <end> col('.') < col('$') - 1 ? 'g$' : '<right>'
vnoremap <end> g$

nnoremap <esc><bs> db
nnoremap <expr> <c-u> col('.') != 1 ? 'd0' : '<up>dd'
inoremap <esc><bs> <c-w>
cnoremap <esc><bs> <c-w>

nnoremap <c-_> u
vnoremap <c-_> <esc>u
inoremap <c-_> <esc>u

nnoremap q: <nop>
nnoremap <c-,> :bprev!<cr>
nnoremap <c-.> :bnext!<cr>
inoremap <c-,> <c-o>:bprev!<cr>
inoremap <c-.> <c-o>:bnext!<cr>
]])
