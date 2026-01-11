return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "hyprlang" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        hyprls = {
          settings = {
            hyprls = {
              preferIgnoreFile = false,
              ignore = { "hyprlock.conf", "hypridle.conf" },
            },
          },
        },
      },
    },
    init = function()
      vim.filetype.add({
        pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
      })
    end,
  },

  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "hyprls",
      },
    },
  },
}
