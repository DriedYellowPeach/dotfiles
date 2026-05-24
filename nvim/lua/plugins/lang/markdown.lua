return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = ":call mkdp#util#install()",
  },
  {
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        code = {
          sign = true,
          width = "block",
          right_pad = 1,
        },
        heading = {
          sign = false,
          icons = {},
        },
        checkbox = {
          enabled = true,
        },
      },
      ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
      config = function(_, opts)
        require("render-markdown").setup(opts)
        Snacks.toggle({
          name = "Render Markdown",
          get = function()
            return require("render-markdown.state").enabled
          end,
          set = function(enabled)
            local m = require("render-markdown")
            if enabled then
              m.enable()
            else
              m.disable()
            end
          end,
        }):map("<leader>um")
      end,
    },
  },
  {
    "hedyhli/markdown-toc.nvim",
    ft = "markdown", -- Lazy load on markdown filetype
    cmd = { "Mtoc" }, -- Or, lazy load on "Mtoc" command
    opts = {
      -- Your configuration here (optional)
    },
  },
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      -- Let nvim-lint be the sole markdownlint source (LazyVim's markdown extra
      -- registers markdownlint-cli2 in BOTH none-ls and nvim-lint -> duplicates).
      -- Drop the none-ls one; nvim-lint handles it via the spec below.
      opts.sources = vim.tbl_filter(function(s)
        return s.name ~= "markdownlint-cli2"
      end, opts.sources or {})
    end,
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          prepend_args = { "--config", vim.fn.stdpath("config") .. "/.markdownlint.jsonc" },
        },
      },
    },
  },
}
