-- Customize Mason plugins

---@type LazySpec
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = {
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
      },
    },
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = {
      ensure_installed = {
        "stylua",
        -- add more arguments for adding more null-ls sources
      },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = {
      ensure_installed = {
        "python",
        -- add more arguments for adding more debuggers
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      local mason_tool_installer = require "mason-tool-installer"
      mason_tool_installer.setup {
        ensure_installed = {
          "prettier", -- prettier formatter
          "stylua", -- lua formatter
          "isort", -- python formatter
          "black", -- python formatter
          "pylint", -- python linter
          "eslint_d", -- js linter
        },
      }
    end,
  },
}
