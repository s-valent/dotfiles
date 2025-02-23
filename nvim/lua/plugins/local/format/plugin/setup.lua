local is_file_valid = require('config.utils').is_file_valid

vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Autoformat Python',
  pattern = { '*.py' },
  callback = function(event)
    if vim.g.skip_format == true then
      return
    end

    local x, y = unpack(vim.api.nvim_win_get_cursor(0))

    if is_file_valid(event.match, '_ruff') then
      vim.cmd('%!ruff check -ns - --stdin-filename % --fix-only')
    end

    if is_file_valid(event.match, '_black') then
      vim.cmd('%!black -q - --stdin-filename % 2> /dev/null')
    end

    vim.api.nvim_input('<esc>')
    x = math.min(x, vim.api.nvim_buf_line_count(0))
    vim.api.nvim_win_set_cursor(0, {x, y})
  end
})

vim.api.nvim_create_user_command('W', function()
  local backup = vim.g.skip_format
  vim.g.skip_format = true
  vim.cmd('w')
  vim.g.skip_format = backup
end, {})

vim.api.nvim_create_user_command('ToggleAutoformat', function()
  vim.g.skip_format = not vim.g.skip_format
end, {})
