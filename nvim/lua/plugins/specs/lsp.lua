local function fetch_ruff_paths()
  local filepath = vim.fn.stdpath('config') .. '/_ruff-paths.txt'
  local contents = vim.fn.system({'cat', filepath})
  local paths = {}
  for value in contents:gmatch('[^\n]+') do
    local path = vim.fn.resolve(vim.fn.expand(value))
    if path ~= '' then
      table.insert(paths, path)
    end
  end
  return paths
end

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'j-hui/fidget.nvim', opts = {} },
    { 'hrsh7th/nvim-cmp', lazy = false },
    { 'hrsh7th/cmp-nvim-lsp', lazy = false },
  },
  config = function()
    local lspconfig_defaults = require('lspconfig').util.default_config
    lspconfig_defaults.capabilities = vim.tbl_deep_extend(
      'force',
      lspconfig_defaults.capabilities,
      require('cmp_nvim_lsp').default_capabilities()
    )

    local ruff_paths = fetch_ruff_paths()
    local should_use_ruff = function(filename)
      for _, path in pairs(ruff_paths) do
        if vim.startswith(filename, path) then
          return true
        end
      end
      return false
    end

    if vim.g.vscode then
      return
    end

    vim.api.nvim_create_autocmd('LspAttach', {
      desc = 'LSP Actions',
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('<leader>f', function() vim.lsp.buf.format({ async = true }) end, '[F]ormat', { 'n' })
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('<leader>hd', vim.lsp.buf.hover, '[H]over [D]ocumentation')
        map('<leader>he', vim.diagnostic.open_float, '[H]over [E]rror Diagnostics')

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.name == 'ruff' then
          client.server_capabilities.hoverProvider = false
          if not should_use_ruff(vim.api.nvim_buf_get_name(event.buf)) then
            -- vim.lsp.buf_detach_client(event.buf, event.data.client_id)
            client.stop()
          end
        end

        vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
          vim.lsp.handlers.signature_help,
          { border = 'single', focusable = false }
        )

        -- hightlight similar
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.signature_help,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end
      end
    })

    local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
    local diagnostic_signs = {}
    for type, icon in pairs(signs) do
      diagnostic_signs[vim.diagnostic.severity[type]] = icon
    end
    vim.diagnostic.config { signs = { text = diagnostic_signs }, update_in_insert = true }
    vim.opt.signcolumn = 'yes'

    local config = require('lspconfig')
    local python_root_files = {
      'pyproject.toml',
      'setup.py',
      'setup.cfg',
      'requirements.txt',
      'Pipfile',
      'pyrightconfig.json',
      '.git',
    }
    function find_python_root(filename)
      local found = require('lspconfig.util').root_pattern(python_root_files)(filename)
      local fallback = vim.fs.dirname(filename)
      return found or fallback
    end

    config.pyright.setup({
      settings = {
        pyright = {
          disableOrganizeImports = true,
        },
        python = {
          analysis = {
            typeCheckingMode = 'off',
            diagnosticMode = 'workspace',
          }
        }
      },
      root_dir = find_python_root,
    })
    config.ruff.setup({
      root_dir = find_python_root,
    })

    local cmp = require('cmp')
    cmp.setup({
      sources = {
        { name = 'nvim_lsp' },
      },
      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      },
      mapping = {
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<down>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<up>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable,
        ['<C-e>'] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
        ['<Esc>'] = cmp.mapping.abort(),
        ['<C-c>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
      }
    })

    vim.lsp.set_log_level('error')
  end
}
