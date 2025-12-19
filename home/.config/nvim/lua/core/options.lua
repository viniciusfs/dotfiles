vim.opt.compatible = false
vim.opt.title = true

vim.opt.termguicolors = true
vim.opt.background = 'dark'
vim.opt.signcolumn = 'yes'

vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.encoding = 'utf-8'
vim.opt.fileformats = { 'unix', 'dos', 'mac' }

vim.opt.cmdheight = 2
vim.opt.showcmd = true
vim.opt.laststatus = 2

vim.opt.statusline = '[%l,%v %L %P] %f %y%m %r%h%w'

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.conceallevel = 2
vim.opt.concealcursor:remove('n')

vim.opt.number = true
vim.opt.cursorline = true

vim.opt.foldmethod = 'indent'
vim.opt.foldlevel = 99

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.winborder = 'rounded'
