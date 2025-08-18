local is_file_valid = require('config.utils').is_file_valid

local function patch_lsp_diagnostics(handler, per_line)
  return {
    show = function(ns, bufnr, diagnostics, opts)
      local ns_name = vim.diagnostic.get_namespace(ns).name
      local file = vim.api.nvim_buf_get_name(bufnr)

      if not vim.startswith(ns_name, 'vim.lsp.') then
        handler.show(ns, bufnr, diagnostics, opts)
        return
      end

      local use_ruff = is_file_valid(file, '_ruff')

      local diagnostics = vim.tbl_filter(
        function(d)
          local ns_name = vim.diagnostic.get_namespace(d.namespace).name
          local is_lsp = vim.startswith(ns_name, 'vim.lsp.')
          local ruff_err = d.source == 'Ruff' and not use_ruff
          return is_lsp and not ruff_err
        end,
        vim.diagnostic.get(bufnr)
      )
      if per_line == true or per_line == nil then
        local max_severity_per_line = {}
        for _, d in pairs(diagnostics) do
          if (d._tags or {}).unnecessary ~= true then
            local m = max_severity_per_line[d.lnum]
            if not m or d.severity < m.severity then
              max_severity_per_line[d.lnum] = d
            end
          end
        end
        diagnostics = vim.tbl_values(max_severity_per_line)
      end

      local filtered_diagnostics = vim.tbl_filter(
        function(val)
          return val.namespace == ns
        end,
        diagnostics
      )
      handler.show(ns, bufnr, filtered_diagnostics, opts)
    end,
    hide = handler.hide,
  }
end

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'j-hui/fidget.nvim', opts = {} },
    { 'hrsh7th/nvim-cmp', lazy = false },
    { 'hrsh7th/cmp-nvim-lsp', lazy = false },
  },
  config = function()
    vim.diagnostic.handlers.signs = patch_lsp_diagnostics(vim.diagnostic.handlers.signs)
    vim.diagnostic.handlers.virtual_text = patch_lsp_diagnostics(vim.diagnostic.handlers.virtual_text)
    vim.diagnostic.handlers.underline = patch_lsp_diagnostics(vim.diagnostic.handlers.underline, false)

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
        end

        vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
          function(_, res, ctx, config)
            if vim.g.hover_signature == true then
              vim.lsp.handlers.signature_help(_, res, ctx, config)
            end
          end,
          { border = 'single', focusable = false }
        )

        -- hightlight similar
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
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
            group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
            callback = function(event)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event.buf }
            end,
          })
        end
      end
    })

    local signs = { ERROR = 'E', WARN = 'W', INFO = 'I', HINT = 'H' }
    local diagnostic_signs = {}
    for type, icon in pairs(signs) do
      diagnostic_signs[vim.diagnostic.severity[type]] = icon
    end
    vim.diagnostic.config { signs = { text = diagnostic_signs }, update_in_insert = true, severity_sort = true }
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
      if not found or not vim.startswith(found, vim.fn.expand('~')) then
        found = fallback
      end
      return found
    end

    config.pyright.setup({
      settings = {
        single_file_support = true,
        pyright = {
          disableOrganizeImports = true,
        },
        python = {
          analysis = {
            autoSearchPaths = true,
            typeCheckingMode = 'off',
            diagnosticMode = 'workspace',
            useLibraryCodeForTypes = true,
          }
        }
      },
      root_dir = find_python_root,
    })
    config.ruff.setup({
      root_dir = find_python_root,
    })
    config.ts_ls.setup({}) -- npm i -g typescript-language-server

    local cmp = require('cmp')
    local mapping = {
      ['<down>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<up>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<c-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-1), { 'i', 'c' }),
      ['<c-f>'] = cmp.mapping(cmp.mapping.scroll_docs(1), { 'i', 'c' }),
      ['<c-y>'] = cmp.config.disable,
      ['<c-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<c-c>'] = cmp.mapping.abort(),
      ['<cr>'] = cmp.mapping.confirm({ select = true }),
    }
    mapping['<tab>'] = mapping['<down>']
    mapping['<s-tab>'] = mapping['<up>']

    cmp.setup({
      sources = {
        { name = 'nvim_lsp' },
      },
      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      },
      mapping = mapping,
      matching = {
        disallow_prefix_unmatching = true,
      }
    })

    vim.keymap.set({ 'n', 'i' }, '<c-h>', function()
      vim.g.hover_signature = not vim.g.hover_signature
    end, { expr = true, remap = true, desc = 'Switch [H]over Signature Help' })
  end
}
