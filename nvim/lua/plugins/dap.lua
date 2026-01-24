return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      -- Override to ensure chrome adapter is excluded from automatic installation
      -- This fixes the opts merge issue between dap/core.lua (true) and typescript.lua (table)
      automatic_installation = { exclude = { "chrome" } },
    },
  },
}
