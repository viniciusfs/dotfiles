return {
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },

  {
    "saghen/blink.cmp",
    opts = {
      -- other configs here...
      completion = {
        menu = { border = "single" },
        documentation = { window = { border = "single" } },
      },
      signature = { window = { border = "single" } },
    },
  },

  {
    "folke/noice.nvim",
    opts = {
      presets = {
        lsp_doc_border = true,
      },
    },
  },
}
