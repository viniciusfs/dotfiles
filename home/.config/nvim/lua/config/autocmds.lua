-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Crossplane Compositions (YAML + Go Template)
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = {
    "composition.yaml",
  },
  callback = function()
    vim.bo.filetype = "yaml.go-template"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "yaml.go-template",
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.expandtab = true
    vim.bo.autoindent = false
    vim.bo.smartindent = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "yaml.go-template",
  callback = function()
    vim.diagnostic.enable(false)
  end,
})
