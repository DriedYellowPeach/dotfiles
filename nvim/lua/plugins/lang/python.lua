-- Buffer-local "run current file" map for Python (<leader>ce, code group).
-- Registered at top level so it runs when lazy imports this spec at startup,
-- instead of as a plugin `init` (which can be clobbered by LazyVim's own spec).
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function(args)
    vim.keymap.set("n", "<leader>ce", function()
      vim.cmd("split | terminal python " .. vim.fn.expand("%:p"))
    end, { buffer = args.buf, desc = "Run current file" })
  end,
})

return {
  {
    "nvim-neotest/neotest",
    opts = {
      adapters = {
        ["neotest-python"] = {
          is_test_file = function(file_path)
            local patterns = { "interview", "test_", "_spec" } -- Add more patterns as needed
            for _, pattern in ipairs(patterns) do
              if file_path:match(pattern) then
                return true
              end
            end
            return false
          end,
        },
      },
    },
  },
}
