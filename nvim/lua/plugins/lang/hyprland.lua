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

  -- Show swatches for Hyprland's rgb(RRGGBB) / rgba(RRGGBBAA) hex colors,
  -- which mini.hipatterns' built-in hex_color highlighter doesn't match.
  {
    "nvim-mini/mini.hipatterns",
    opts = function(_, opts)
      local hipatterns = require("mini.hipatterns")
      opts.highlighters = opts.highlighters or {}
      opts.highlighters.hypr_color = {
        pattern = "rgba?%(%x+%)",
        group = function(_, match)
          local hex = match:match("%((%x+)%)")
          if hex == nil then
            return nil
          end
          if #hex == 8 then
            hex = hex:sub(1, 6) -- drop the alpha channel for the swatch
          elseif #hex ~= 6 then
            return nil
          end
          return hipatterns.compute_hex_color_group("#" .. hex, "bg")
        end,
        extmark_opts = { priority = 2000 },
      }
    end,
  },
}
