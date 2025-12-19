-- Mason
require('mason').setup()

require('mason-lspconfig').setup({
  ensure_installed = {
    'pyright',
    'gopls',
    'terraformls',
    'ruff',
    'lua_ls',
  },
})

-- Capabilities (LSP -> completion)
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Python
vim.lsp.config('pyright', {
  capabilities = capabilities,
})

-- Python - Ruff (formatter + lint)
vim.lsp.config('ruff', {
  capabilities = capabilities,
})

-- Go
vim.lsp.config('gopls', {
  capabilities = capabilities,
  settings = {
    gopls = {
      gofumpt = true,
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
    },
  },
})

-- Terraform / HCL
vim.lsp.config('terraformls', {
  capabilities = capabilities,
})

-- Lua
vim.lsp.config('lua_ls', {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})
