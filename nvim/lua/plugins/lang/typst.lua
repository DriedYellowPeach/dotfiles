return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "typst" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tinymist = {
          settings = {
            formatterMode = "typstyle",
            exportPdf = "onType",
            outputPath = "$root/target/$dir/$name",
          },
          on_attach = function(client, bufnr)
            vim.keymap.set("n", "<leader>cp", function()
              client:exec_cmd({
                title = "pin",
                command = "tinymist.pinMain",
                arguments = { vim.api.nvim_buf_get_name(bufnr) },
              }, { bufnr = bufnr })
              vim.notify("Pinned: " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
            end, { buffer = bufnr, desc = "Tinymist Pin Main" })

            vim.keymap.set("n", "<leader>cu", function()
              client:exec_cmd({
                title = "unpin",
                command = "tinymist.pinMain",
                arguments = { vim.v.null },
              }, { bufnr = bufnr })
              vim.notify("Unpinned main file", vim.log.levels.INFO)
            end, { buffer = bufnr, desc = "Tinymist Unpin Main" })
          end,
        },
      },
    },
    init = function()
      vim.filetype.add({ extension = { typ = "typst" } })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "typst" },
        callback = function()
          vim.opt_local.spell = true
        end,
      })
    end,
  },

  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    opts = {},
  },

  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "tinymist",
      },
    },
  },
}
