local toggle_key = "<C-\\>"

return {
  {
    "coder/claudecode.nvim",
    keys = {
      { toggle_key, "<cmd>ClaudeCodeFocus<cr>", desc = "Claude Code", mode = { "n", "t" } },
    },
    opts = {
      terminal = {
        -- Custom floating-window terminal provider. See utils/float_term.lua.
        provider = require("utils.float_term"),
      },
      diff_provider = "native",
      diff_opts = {
        keep_terminal_focus = true,
      },
    },
    config = function(_, opts)
      require("claudecode").setup(opts)
      local map = LazyVim.safe_keymap_set
      map("n", "<leader>ak", require("utils.float_term").kill, { desc = "Kill Claude Code terminal" })
    end,
  },
}
