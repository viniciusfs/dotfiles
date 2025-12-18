-- Mason
require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = {
    "pyright",
    "gopls",
    "terraformls",
    "ruff",
  },
})

-- Capabilities (LSP -> completion)
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities()


-- Python
vim.lsp.config("pyright", {
  capabilities = capabilities,
})

-- Python - Ruff (formatter + lint)
vim.lsp.config("ruff", {
  capabilities = capabilities,
})

-- Go
vim.lsp.config("gopls", {
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
vim.lsp.config("terraformls", {
  capabilities = capabilities,
})

