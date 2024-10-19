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
      { "jose-elias-alvarez/null-ls.nvim" },
    },
    config = function()
      local lsp_zero = require "lsp-zero"
      local function sanitize_hover_content(content)
        -- Strip HTML entities like &nbsp;
        return content:gsub("&nbsp;", " ")
      end

      -- Customize hover window
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded", -- Customize border, options: "none", "single", "double", "rounded", "solid", "shadow"
        max_width = 80, -- Set the max width of the hover window
        max_height = 50, -- Set the max height of the hover window
        wrap = true, -- Enable text wrapping for better readability
        focusable = true, -- Make the hover window focusable
        padding = { 1, 1, 1, 1 }, -- Add padding around content
        borderchars = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }, -- Custom border characters
        wrap_at = 80, -- Set wrapping at 80 characters
        synchronous = false, -- Allow asynchronous hover content
        before_open = function(_, result, ctx, config)
          if result and result.contents then
            if type(result.contents) == "string" then
              result.contents = sanitize_hover_content(result.contents)
            elseif type(result.contents) == "table" then
              for i, content in ipairs(result.contents) do
                if type(content) == "string" then result.contents[i] = sanitize_hover_content(content) end
              end
            end
          end
          return vim.lsp.handlers.hover(_, result, ctx, config)
        end,
      })

      -- lsp_attach function for keymaps
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
        },
        on_attach = lsp_attach,
      }

      -- Customize hover window for lspinfo and help
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "markdown",
        callback = function()
          vim.opt_local.list = false -- Disable listchars in floating windows
        end,
      })

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
