-- LSP UI
local border = 'rounded'

vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#5e81ac' }) -- #5e81ac

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = border,
})

vim.lsp.handlers['textDocument/signatureHelp'] =
  vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = border,
  })

vim.diagnostic.config({
  float = {
    border = border,
  },
})

vim.diagnostic.config({
  float = {
    border = border,
    source = 'always',
    header = '',
    prefix = '',
  },
  virtual_text = {
    spacing = 4,
    prefix = '●',
  },
  underline = true,
  update_in_insert = false,
})
