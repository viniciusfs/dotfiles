return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      "yaml",
      "go",
      "gotmpl",
      "css",
      "scss",
      "html",
    })

    -- hybrid file type yaml + go template
    vim.treesitter.language.register("yaml", "yaml.go-template")
    vim.treesitter.language.register("gotmpl", "yaml.go-template")
  end,
}
