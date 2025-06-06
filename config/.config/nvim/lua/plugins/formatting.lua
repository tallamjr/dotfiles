return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require "conform"

    conform.setup {
      formatters_by_ft = {
        css = { "prettier" },
        graphql = { "prettier" },
        html = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        lua = { "stylua" },
        -- markdown = { "prettier" }, -- Disabled to preserve manual formatting
        python = { "isort", "black", "ruff" },
        rust = { "rustfmt", lsp_format = "fallback" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        yaml = { "prettier" },
      },
      format_on_save = function(bufnr)
        -- Disable auto-format on save for markdown files
        if vim.bo[bufnr].filetype == "markdown" then return false end
        return {
          lsp_fallback = true,
          async = false,
          timeout_ms = 3000,
        }
      end,
    }

    vim.keymap.set(
      { "n", "v" },
      "<leader>mp",
      function()
        conform.format {
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        }
      end,
      { desc = "Format file or range (in visual mode)" }
    )
  end,
}
