return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigatorLeft",
    "TmuxNavigatorRight",
    "TmuxNavigatorUp",
    "TmuxNavigatorDown",
  },
  keys = {
    { "<c-h>", ":TmuxNavigatorLeft<cr>" },
    { "<c-j>", ":TmuxNavigatorDown<cr>" },
    { "<c-k>", ":TmuxNavigatorUp<cr>" },
    { "<c-l>", ":TmuxNavigatorRight<cr>" },
  },
}
