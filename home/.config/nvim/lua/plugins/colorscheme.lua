return {
  {
    dir = "~/Code/personal/void-space.nvim/",
    -- "viniciusfs/void-space.nvim",
    name = "void-space",
    lazy = false, -- must be loaded at startup
    priority = 1000, -- load before other UI plugins
    opts = {
      italic_comments = true,
      italic_keywords = true,
      transparent = false,
      dim_inactive = false,
      variant = "default",
      dev = true,
    },
    config = function(_, opts)
      require("void-space").setup(opts)
    end,
  },

  {
    "danfry1/lume",
  },

  { "catppuccin/nvim", name = "catppuccin" },

  { "metalelf0/jellybeans-nvim" },

  { "mohseenrm/brutus" },

  { "tyrannicaltoucan/vim-deep-space" },

  { "Aejkatappaja/sora" },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },

  { "LazyVim/LazyVim", opts = { colorscheme = "void-space" } },
}
