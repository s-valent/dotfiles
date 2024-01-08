return {
  {
    'tpope/vim-dadbod',
    dependencies = {
      'kristijanhusak/vim-dadbod-completion',
      'kristijanhusak/vim-dadbod-ui',
      'pbogut/vim-dadbod-ssh',
    },
    priority = 15,
    config = function()
      local cmp = require('cmp')
      cmp.setup.filetype({ 'sql' }, {
        sources = {
          { name = 'vim-dadbod-completion' },
          { name = 'buffer' },
        }
      })

      vim.g.db_ui_table_helpers = {
        postgresql = {
          Count = 'select count(*) from "{table}"'
        }
      }

      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufLeave', 'InsertEnter' }, {
        pattern = { '/var/*-query-*', '*/.local/share/db_ui/*' },
        command = 'set wrap',
      })

      -- vim.api.nvim_create_autocmd({ 'FileType' }, {
      --   pattern = 'dbout',
      --   command = 'setlocal virtualedit=all',
      -- })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'dbout',
        callback = function()
          vim.opt_local.foldenable = false
          vim.opt_local.virtualedit = 'all'
        end,
      })
    end
  }
}
