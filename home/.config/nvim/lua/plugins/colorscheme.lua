return {
  {
    dir = "~/Code/personal/void-space.nvim/",
    name = "void-space",
    lazy = false, -- must be loaded at startup
    priority = 1000, -- load before other UI plugins
    opts = {
      italic_comments = true,
      italic_keywords = true,
      transparent = false,
      dim_inactive = false,
      variant = "default",
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

  { "LazyVim/LazyVim", opts = { colorscheme = "void-space" } },
}
