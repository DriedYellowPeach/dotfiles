local function get_project_rustanalyzer_settings()
  local handle = io.open(vim.fn.resolve(vim.fn.getcwd() .. "/./.rust-analyzer.json"))
  if not handle then
    return {}
  end
  local out = handle:read("*a")
  handle:close()
  local config = vim.json.decode(out)
  if type(config) == "table" then
    return config
  end
  return {}
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      codelens = {
        enabled = true,
      },
      setup = {
        rust_analyzer = function()
          return true
        end,
      },
    },
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    -- nvim-dap must load before rust-analyzer attaches, else rustaceanvim won't
    -- advertise `debugSingle` and the Debug code lens is hidden.
    dependencies = { "mfussenegger/nvim-dap" },
    -- NOTE: this MUST go through `vim.g.rustaceanvim` in `init`, not through
    -- `opts.dap`. LazyVim's rust extra assigns `opts.dap = { adapter = ... }`
    -- wholesale (extras/lang/rust.lua:114), which discards anything we put in
    -- `opts.dap`. It then merges with `tbl_deep_extend("keep", vim.g.rustaceanvim, opts)`
    -- (line 118), so a value already present in `vim.g.rustaceanvim` wins, and
    -- `init` runs before `config`. This keeps LazyVim's codelldb adapter.
    --
    -- Why disable it: on rust-analyzer init, rustaceanvim requests every
    -- runnable in the workspace and *executes* each one's cargo command just to
    -- learn the output binary path, to prepopulate `require('dap').continue()`.
    -- In bevy that includes the crate-level test suite runnable, i.e.
    -- `cargo test --no-run --package bevy --all-targets`, which links all ~357
    -- examples at ~1.5 GB each (533 GB). `:RustLsp debuggables` and
    -- `<leader>dd` / `<leader>dr` still build only the target you pick.
    init = function()
      vim.g.rustaceanvim = vim.tbl_deep_extend("force", vim.g.rustaceanvim or {}, {
        dap = {
          autoload_configurations = false,
        },
      })
    end,
    opts = {
      tools = {
        -- executor = executors.termopen,
        -- reload_workspace_from_cargo_toml = true,
        float_win_config = {
          border = "rounded",
        },
        -- disable it because there is a change in neovim 0.10, refersh codelens will try to refresh all buffers
      },
      server = {
        on_attach = function(_, bufnr)
          -- NOTE: key map for expandMacro
          vim.keymap.set("n", "<leader>ce", function()
            vim.cmd.RustLsp("expandMacro")
          end, { desc = "Expand Macro", buffer = bufnr })
          -- NOTE: debug current line
          vim.keymap.set("n", "<leader>dd", function()
            vim.cmd.RustLsp("debug")
          end, { desc = "Rust Debug line", buffer = bufnr })
          -- NOTE: key map for all debuggables
          vim.keymap.set("n", "<leader>dr", function()
            vim.cmd.RustLsp("debuggables")
          end, { desc = "Rust Debuggables", buffer = bufnr })
        end,
        default_settings = {
          -- NOTE: rust-analyzer language server configuration
          ["rust-analyzer"] = vim.tbl_deep_extend(
            "force",
            -- NOTE: Default settings
            {
              -- lens.run/debug/implementations/updateTest are on by default.
              -- To show reference counts (off by default), enable references, e.g.:
              --   lens = { references = { adt = { enable = true }, method = { enable = true } } }
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = {
                  enable = true,
                },
              },
              -- Add clippy lints for Rust.
              checkOnSave = {
                enable = true,
                command = "clippy",
              },
              procMacro = {
                enable = true,
                -- NOTE: don't set `ignored = {}` here. An empty Lua table
                -- serializes to JSON `[]`, but rust-analyzer expects a map for
                -- procMacro.ignored and rejects it ("expected a map"). If you
                -- need entries, add them as `["crate"] = { "macro" }`.
              },
              diagnostics = {
                enable = true,
                disabled = { "unresolved-proc-macro", "proc-macro-disabled" },
                enableExperimental = true,
              },
            },
            -- NOTE: load .rust-analyzer.json if exists
            get_project_rustanalyzer_settings()
          ),
        },
      },
    },
    -- NOTE: no custom `config` here. LazyVim's rust extra `config` wires up the
    -- codelldb DAP adapter (`opts.dap`); overriding it drops the adapter.
  },
}
