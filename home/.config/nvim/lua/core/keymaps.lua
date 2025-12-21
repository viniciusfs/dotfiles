local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Toggles
map('n', '<F2>', function()
  vim.opt.number = not vim.opt.number:get()
end, opts)

map('n', '<F3>', function()
  vim.opt.cursorline = not vim.opt.cursorline:get()
end, opts)

-- Folding
map('n', '<space>', 'za', opts)

map('n', '<C-n>', function()
  require('nvim-tree.api').tree.toggle()
end, opts)

-- Split navigation
map('n', '<C-J>', '<C-W><C-J>', opts)
map('n', '<C-K>', '<C-W><C-K>', opts)
map('n', '<C-L>', '<C-W><C-L>', opts)
map('n', '<C-H>', '<C-W><C-H>', opts)

-- LSP keymaps
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    -- Navigation
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

    -- Diagnostics
    vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, opts)
    vim.keymap.set('n', ']d', function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, opts)
    vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, opts)

    -- Info
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end,
})
