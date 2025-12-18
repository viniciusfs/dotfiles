local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Toggles
map("n", "<F2>", function() vim.opt.number = not vim.opt.number:get() end, opts)
map("n", "<F3>", function() vim.opt.cursorline = not vim.opt.cursorline:get() end, opts)

map("n", "<F4>", function()
  if vim.opt.colorcolumn:get()[1] then
    vim.opt.colorcolumn = ""
  else
    vim.opt.colorcolumn = "80"
  end
end, opts)

map("n", "<F5>", ":IndentLinesToggle<CR>", opts)

-- Folding
map("n", "<space>", "za", opts)

map("n", "<C-n>", function()
  require("nvim-tree.api").tree.toggle()
end, opts)

-- Terminal
map("n", "<F10>", ":term<CR>", opts)

-- Split navigation
map("n", "<C-J>", "<C-W><C-J>", opts)
map("n", "<C-K>", "<C-W><C-K>", opts)
map("n", "<C-L>", "<C-W><C-L>", opts)
map("n", "<C-H>", "<C-W><C-H>", opts)

-- LSP keymaps
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end,
})

