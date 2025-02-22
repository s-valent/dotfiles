local is_file_valid = require('config.utils').is_file_valid

vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Autoformat Python',
  pattern = { '*.py' },
  callback = function(event)
    local ruff = is_file_valid(event.file, '_ruff')
    local black = is_file_valid(event.file, '_black')

    if black or ruff then
      vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
        callback = function()
          if vim.g.skip_format == true then
            return
          end

          if black then
            local x, y = unpack(vim.api.nvim_win_get_cursor(0))
            vim.cmd('%!black -q - --stdin-filename % 2> /dev/null')
            vim.api.nvim_input('<esc>')
            x = math.min(x, vim.api.nvim_buf_line_count(0))
            vim.api.nvim_win_set_cursor(0, {x, y})
          end

          if ruff then
            vim.lsp.buf.code_action({
              context = { only = { "source.fixAll.ruff" } },
              apply = true
            })
          end

        end
      })
    end
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
