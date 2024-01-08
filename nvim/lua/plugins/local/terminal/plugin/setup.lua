function _G.on_bufenter()
  local buf = vim.api.nvim_get_current_buf()
  local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
  if buftype == 'terminal' then
    if vim.api.nvim_get_mode().mode == 'i' then
      vim.api.nvim_input('<esc>i')
    else
      vim.cmd('startinsert')
    end
  end
end

function _G.unset_paste()
  local buf = vim.api.nvim_get_current_buf()
  vim.keymap.set('n', 'p', '<nop>', { noremap = true, buffer = buf })
end

vim.api.nvim_exec([[
  autocmd TermOpen * setlocal nonumber norelativenumber nocursorline nobuflisted
  autocmd TermOpen * lua unset_paste()
  autocmd TermOpen * startinsert
  " autocmd BufEnter * lua on_bufenter()

  cnoreabbrev ht split\|terminal
  cnoreabbrev vt vsplit\|terminal
]], false)
