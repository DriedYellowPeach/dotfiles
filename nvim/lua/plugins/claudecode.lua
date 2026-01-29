local toggle_key = "<C-\\>"

return {
  {
    "coder/claudecode.nvim",
    keys = {
      { toggle_key, "<cmd>ClaudeCodeFocus<cr>", desc = "Claude Code", mode = { "n", "t" } },
    },
    opts = {
      terminal = {
        provider = require("utils.float_term"),
      },
      diff_provider = "native",
      diff_opts = {
        keep_terminal_focus = true,
      },
    },
  },
}
