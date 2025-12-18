-- ~/.config/nvim/lua/plugins/cmp.lua

local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      -- sem snippets por enquanto (simples)
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),

  sources = {
    { name = "nvim_lsp" },
  },
})

