return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.diagnostics.virtual_text = false

      -- crossplane compositions yaml
      opts.servers = opts.servers or {}
      opts.servers.yamlls = opts.servers.yamlls or {}
      opts.servers.yamlls.settings = vim.tbl_deep_extend("force", opts.servers.yamlls.settings or {}, {
        yaml = {
          validate = false,
          hover = true,
          completion = true,
          schemaStore = {
            enable = true,
          },
        },
      })
    end,
  },
}
