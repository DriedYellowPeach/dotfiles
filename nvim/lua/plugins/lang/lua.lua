return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = "Lua 5.4",
              },
              hint = {
                enable = true,
                setType = true,
                paramType = true,
                paramName = "All",
                semicolon = "Disable",
                arrayIndex = "Enable",
              },
              workspace = {
                library = {
                  -- vim.fn.expand("$VIMRUNTIME/lua"),
                  -- vim.fn.stdpath("data") .. "/lazy",
                },
                checkThirdParty = false,
              },
            },
          },
        },
      },
    },
  },
}
