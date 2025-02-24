return {
  'echasnovski/mini.diff',
  version = '*',
  config = function()
    local diff = require('mini.diff')
    diff.setup({
      view = {
        style = 'sign',
        signs = { add = '┃', change = '┃', delete = '_' },
        priority = 0,
      },
      source = diff.gen_source.none(),
    })

    local reset_hunk = function()
      return MiniDiff.operator('reset') .. 'gh'
    end

    vim.keymap.set('n', '<leader>hr', reset_hunk, { expr = true, remap = true, desc = '[H]unk [R]eset' })
    vim.keymap.set('n', '<leader>ht', MiniDiff.toggle_overlay, { remap = true, desc = '[H]unk [T]oggle' })

    local set_diff = function()
      if vim.b.diff == nil then
        local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        MiniDiff.set_ref_text(0, content)
        vim.b.diff = true
      end

      local ref = vim.g.commit or 'HEAD'
      local path = vim.system({ 'git', 'ls-files', '--full-name', vim.fn.expand('%') }):wait().stdout:gsub("\n", "")
      if path == "" then
        return
      end

      local content = vim.system({ 'git', 'show', ref .. ':' .. path }):wait().stdout
      MiniDiff.set_ref_text(0, content)
    end

    vim.api.nvim_create_autocmd('BufEnter', {
      desc = 'SetDiffSource',
      callback = set_diff,
    })

    vim.api.nvim_create_user_command('DiffReload', set_diff, {})
    vim.api.nvim_create_user_command('Diff', function()
      vim.cmd [[
        cexpr system("git diff -U1 --compact-summary --dst-prefix=$(echo $(git rev-parse --show-toplevel)'/') | grep -oE '^[+][+][+].*|^@@[^@]*' | sed 's/@@ [-,0-9]* +\\([0-9]*\\)/:\\1:1/g' | sed '/^+++/{N;s/+++ \\(.*\\)\\n\\(.*\\)/\\1\\2/;}'") | copen
      ]]
    end, {})
  end
}
