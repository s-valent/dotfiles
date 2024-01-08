return {
  {
  'nvim-tree/nvim-tree.lua',
  config = function(_, opts)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require('nvim-tree').setup({
      sort = { sorter = 'case_sensitive' },
      view = { width = 30 },
      filters = { dotfiles = false },
      git = { enable = false },
      renderer = {
        group_empty = true,
        icons = {
          show = {
            file = false,
            folder = false,
            folder_arrow = false,
            git = false,
          }
        }
      }
    })

    -- close on buffer exit
    vim.api.nvim_create_autocmd({'QuitPre'}, {
      callback = function() vim.cmd('NvimTreeClose') end,
    })

    vim.keymap.set('n', '<C-l>', ':NvimTreeToggle<cr>', { noremap = true })
  end
  }
}
