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

    local set_diff = function(args)
      if vim.b.diff == nil then
        local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        MiniDiff.set_ref_text(0, content)
        vim.b.diff = true
      end

      local ref = vim.g.commit or ''
      local root = vim.system({ 'git', 'rev-parse', '--show-toplevel' }):wait().stdout:gsub('\n', '')
      local path = vim.system({ 'git', 'ls-files', '--full-name', vim.fn.expand('%') }):wait().stdout:gsub('\n', '')
      if path == "" then
        return
      end

      local content = vim.system({ 'git', 'show', ref .. ':' .. path }):wait().stdout
      MiniDiff.set_ref_text(0, content)

      vim.api.nvim_create_user_command('Diff', function(args)
        local cmd = 'git diff -U0'
        args = args.args
        if args == '' then
          args = ref
        end
        local diff = vim.system({ 'sh', '-c', cmd .. ' ' .. args }):wait().stdout
        local entries = {}

        local file
        for value in diff:gmatch('[^\n]+') do
          if value:match('^--- a') then
            file = value:gsub('^--- a', root)
          elseif value:match('^+++ b') then
            file = value:gsub('^+++ b', root)
          elseif value:match('^@@') then
            local i, j = value:find('+[0-9]+')
            local lnum = value:sub(i, j):gsub('+', '')
            if lnum == '0' then
              lnum = '1'
            end
            local blame = vim.system({ 'git', 'blame', file, '-L', lnum .. ',' .. lnum }):wait().stdout
            i, j = blame:find('%([^)]+%)')
            local text = ""
            if i and j then
              text = blame:sub(i, j)
            end

            entries[#entries + 1] = { filename = file, lnum = lnum, text = text }
          end
        end

        local dir = vim.fn.getcwd()
        local status = vim.system({ 'git', 'status', '-s' }):wait().stdout
        for value in status:gmatch('[^\n]+') do
          if value:match('^ *%?+ *') then
            file = value:gsub('^ *[^ ]+ *', '')
            entries[#entries+1] = { filename = dir .. '/' .. file, lnum = 1, text = '(Untracked)'  }
          end
        end

        -- TODO: added empty files

        vim.fn.setqflist(entries)
        vim.cmd.copen()
      end, { nargs = '*' })
    end

    vim.api.nvim_create_user_command('SetDiff', function(args)
      vim.g.commit = args.args
      set_diff()
    end, { nargs = '*' })


    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWrite' }, {
      desc = 'SetDiffSource',
      callback = set_diff,
    })
  end
}
