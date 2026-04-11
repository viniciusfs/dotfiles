return {
  "akinsho/bufferline.nvim",
  opts = {
    options = {
      numbers = "buffer_id",
      indicator = {
        style = "underline",
      },
      offsets = {
        {
          filetype = "neo-tree",
          text = "Explorer",
          highlight = "Directory",
          separator = true,
        },
        {
          filetype = "snacks_layout_box",
          text = "Explorer",
          highlight = "Directory",
          separator = true,
        },
      },
    },
  },
}
