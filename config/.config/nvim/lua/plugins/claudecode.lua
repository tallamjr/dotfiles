return {
  "coder/claudecode.nvim",
  dependencies = {
    {
      "folke/snacks.nvim",
      opts = {},
    },
  },
  config = true,
  opts = {
    -- Terminal opens as a bottom horizontal split taking 30% height
    terminal = {
      provider = "snacks",
      snacks_win_opts = {
        position = "bottom",
        height = 0.30,
        keys = {
          term_normal = {
            "<C-n>",
            function() vim.cmd("stopinsert") end,
            mode = "t",
            desc = "Enter normal mode",
          },
          scroll_up = {
            "<C-u>",
            function()
              vim.cmd("stopinsert")
              vim.cmd("normal! \\<C-u>")
            end,
            mode = "t",
            desc = "Scroll up",
          },
          scroll_down = {
            "<C-d>",
            function()
              vim.cmd("stopinsert")
              vim.cmd("normal! \\<C-d>")
            end,
            mode = "t",
            desc = "Scroll down",
          },
        },
      },
    },
    -- Automatically focus the Claude terminal after sending a selection
    focus_after_send = true,
    -- Diff review settings
    diff_opts = {
      auto_close_on_accept = true,
      vertical_split = true,
    },
  },
  keys = {
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>aR", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add buffer to Claude" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
}
