local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- Colorschemes
  {
    'tyrannicaltoucan/vim-deep-space',
    priority = 1000,
    config = function()
      require('core.theme')
    end,
  },
  { 'rose-pine/vim' },

  -- UI
  { 'Yggdroot/indentLine' },
  { 'ntpeters/vim-better-whitespace' },
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup({
        disable_netrw = true,
        hijack_netrw = true,

        view = {
          width = 30,
          side = 'left',
        },

        renderer = {
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },

        filters = {
          dotfiles = false,
        },

        git = {
          enable = true,
        },
      })
    end,
  },

  -- Languages
  { 'tmhedberg/SimpylFold' },
  { 'vim-scripts/indentpython.vim' },

  { 'godlygeek/tabular' },
  { 'preservim/vim-markdown' },

  { 'hashivim/vim-terraform' },

  -- AI
  { 'Exafunction/windsurf.vim' },

  -- LSP core
  { 'neovim/nvim-lspconfig' },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },

  -- Completion
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
})
