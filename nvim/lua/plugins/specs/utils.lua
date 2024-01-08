return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      {
        '??',
        function()
          require('which-key').show({ global = false })
          vim.opt.updatetime = 0
          vim.opt.timeoutlen = 0
        end,
        desc = 'Buffer Local Keymaps (which-key)',
      }
    }
  },
  {
    'samjwill/nvim-unception',
    init = function()
        -- vim.g.unception_open_buffer_in_new_tab = true

        vim.api.nvim_create_autocmd(
          'User',
          {
            pattern = 'UnceptionEditRequestReceived',
            callback = function()
              vim.cmd('wincmd w')
            end
          }
        )
    end
  },
  'wsdjeg/vim-fetch',
}
