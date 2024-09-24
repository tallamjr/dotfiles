return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
  opts = {
    focus = true,
  },
  cmd = "Trouble",
  keys = {
    { "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open trouble workspace diagnostics" },
    { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Open trouble document diagnostics" },
    { "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Open trouble quickfix list" },
    { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Open trouble location list" },
    { "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Open todos in trouble" },
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
    { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
    {
      "<leader>cl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
    { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
  },
  -- config = function()
  --   -- Setup for trouble.nvim
  --   require("trouble").setup {
  --     position = "bottom", -- Position of the trouble window (can be top, bottom, left, right)
  --     height = 10, -- Height of the trouble window (for top/bottom)
  --     width = 50, -- Width of the trouble window (for left/right)
  --     icons = true, -- Enable icons (requires nvim-web-devicons)
  --     mode = "workspace_diagnostics", -- Default mode (can be "workspace_diagnostics", "document_diagnostics", etc.)
  --     auto_open = false, -- Automatically open when diagnostics are found
  --     auto_close = true, -- Automatically close when no diagnostics are left
  --     use_diagnostic_signs = true, -- Use the LSP diagnostic signs
  --   }
  --
  --   -- Enable inline diagnostics (virtual text)
  --   vim.diagnostic.config {
  --     virtual_text = {
  --       -- prefix = "●", -- Symbol to use for virtual text (change this if you'd like)
  --       spacing = 4, -- Spacing between the code and the virtual text
  --     },
  --     signs = true, -- Show signs in the sign column
  --     underline = true, -- Underline the text that has diagnostics
  --     update_in_insert = false, -- Don't update diagnostics in insert mode
  --     severity_sort = true, -- Sort diagnostics by severity
  --   }
  --
  --   -- Custom symbols for diagnostics (if you want different symbols for LSP signs)
  --   local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  --   for type, icon in pairs(signs) do
  --     local hl = "DiagnosticSign" .. type
  --     vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  --   end
  -- end,
}
