-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- NOTE: Using fmorroni's fork with GitHub-style callouts/alerts support.
-- The upstream toppair/peek.nvim does not render [!NOTE], [!WARNING], [!TIP],
-- [!IMPORTANT], [!CAUTION] blockquotes. This fork implements PR #68 which adds
-- Obsidian-style callout rendering (same syntax as GitHub alerts).
-- See: https://github.com/toppair/peek.nvim/pull/68
-- Revert to "toppair/peek.nvim" once PR #68 is merged upstream.
return {
  "fmorroni/peek.nvim",
  branch = "callouts",
  event = { "VeryLazy" },
  build = "deno task --quiet build:fast",
  keys = {
    { "<leader>mo", "<cmd>PeekOpen<cr>", desc = "Open Markdown Preview" },
    { "<leader>mc", "<cmd>PeekClose<cr>", desc = "Close Markdown Preview" },
  },
  config = function()
    -- default config:
    require("peek").setup {
      auto_load = true, -- whether to automatically load preview when
      -- entering another markdown buffer
      close_on_bdelete = true, -- close preview window on buffer delete

      syntax = true, -- enable syntax highlighting, affects performance

      theme = "light", -- 'dark' or 'light'

      update_on_change = true,

      app = "browser", -- 'webview', 'browser', string or a table of strings
      -- explained below

      filetype = { "markdown" }, -- list of filetypes to recognize as markdown

      -- relevant if update_on_change is true
      throttle_at = 200000, -- start throttling when file exceeds this
      -- amount of bytes in size
      throttle_time = "auto", -- minimum amount of time in milliseconds
      -- that has to pass before starting new render
    }
    vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
    vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
  end,
}
