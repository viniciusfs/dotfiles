-- LSP UI
vim.diagnostic.config({
  virtual_text = false,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
    focusable = false,
    max_width = 80,
  },

  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✘',
      [vim.diagnostic.severity.WARN] = '▲',
      [vim.diagnostic.severity.INFO] = '●',
      [vim.diagnostic.severity.HINT] = '•',
    },
  },
})

vim.cmd([[
  highlight DiagnosticUnderlineError gui=undercurl
  highlight DiagnosticUnderlineWarn  gui=undercurl
  highlight DiagnosticUnderlineInfo  gui=underline
  highlight DiagnosticUnderlineHint  gui=underline
]])
