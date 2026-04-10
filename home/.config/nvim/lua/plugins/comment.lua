return {
  "numToStr/Comment.nvim",
  opts = {
    pre_hook = function()
      if vim.bo.filetype == "yaml.go-template" then
        return "# %s"
      end
    end,
  },
}
