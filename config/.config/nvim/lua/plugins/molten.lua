if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
-- NOTE: Currently not working, see https://github.com/benlubas/molten-nvim/issues/60

vim.g.python3_host_prog = "/opt/homebrew/Caskroom/miniforge/base/envs/main/bin/python"

return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    dependencies = { "willothy/wezterm.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
      -- these are examples, not defaults. Please see the readme
      vim.g.molten_image_provider = "wezterm.nvim"
      vim.g.molten_output_win_max_height = 20
    end,
  },
  -- {
  --   -- see the image.nvim readme for more information about configuring this plugin
  --   "3rd/image.nvim",
  --   opts = {
  --     backend = "kitty", -- whatever backend you would like to use
  --     max_width = 100,
  --     max_height = 12,
  --     max_height_window_percentage = math.huge,
  --     max_width_window_percentage = math.huge,
  --     window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
  --     window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
  --   },
  -- },
  vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>", { silent = true, desc = "Initialize the plugin" }),
  vim.keymap.set(
    "n",
    "<localleader>e",
    ":MoltenEvaluateOperator<CR>",
    { silent = true, desc = "run operator selection" }
  ),
  vim.keymap.set("n", "<localleader>rl", ":MoltenEvaluateLine<CR>", { silent = true, desc = "evaluate line" }),
  vim.keymap.set("n", "<localleader>rr", ":MoltenReevaluateCell<CR>", { silent = true, desc = "re-evaluate cell" }),
  vim.keymap.set(
    "v",
    "<localleader>r",
    ":<C-u>MoltenEvaluateVisual<CR>gv",
    { silent = true, desc = "evaluate visual selection" }
  ),
}
