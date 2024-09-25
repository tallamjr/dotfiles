return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v4.x",
    lazy = true,
    config = false,
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = true,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspInstall", "LspStart" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "jose-elias-alvarez/null-ls.nvim" }, -- For null-ls code actions, note this plugin is nowarchived: https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1621
    },
    config = function()
      local lsp_zero = require "lsp-zero"

      -- lsp_attach is where you enable features that only work
      -- if there is a language server active in the file
      local lsp_attach = function(client, bufnr)
        local opts = { buffer = bufnr }

        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "Show hover information" })
        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to definition" })
        vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { desc = "Go to declaration" })
        vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", { desc = "Go to implementation" })
        vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { desc = "Go to type definition" })
        vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", { desc = "Find references" })
        vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { desc = "Show signature help" })
        vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename symbol" })
        vim.keymap.set(
          { "n", "x" },
          "<F3>",
          "<cmd>lua vim.lsp.buf.format({ async = true })<cr>",
          { desc = "Format code" }
        )
        vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Show code actions" })
        -- Keymap for triggering code actions (manual import fixes)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Show code actions (manual import fixes)" })
      end

      lsp_zero.extend_lspconfig {
        sign_text = true,
        lsp_attach = lsp_attach,
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      }

      require("mason-lspconfig").setup {
        ensure_installed = { "rust_analyzer" }, -- Ensure rust_analyzer is installed
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup {
              on_attach = lsp_attach,
              capabilities = require("cmp_nvim_lsp").default_capabilities(),
            }
          end,
        },
      }

      -- null-ls setup for code actions
      local null_ls = require "null-ls"
      null_ls.setup {
        sources = {
          null_ls.builtins.code_actions.gitsigns,
          null_ls.builtins.code_actions.refactoring,
          -- Add other code actions as needed
        },
        on_attach = lsp_attach,
      }

      -- Automatically apply missing imports on save for Rust files
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.rs",
        callback = function()
          local params = vim.lsp.util.make_range_params()
          params.context = { diagnostics = vim.diagnostic.get(0) }
          local results = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)

          if results then
            for _, res in pairs(results) do
              for _, action in pairs(res.result or {}) do
                if action.kind == "quickfix" and action.title:match "Add import" then
                  -- Apply the code action
                  if action.edit then
                    vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
                  elseif action.command then
                    vim.lsp.buf.execute_command(action.command)
                  end
                end
              end
            end
          end
        end,
      })
    end,
  },
}
