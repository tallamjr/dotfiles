-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "kj", "<esc>", { desc = "Lazy" }) -- new esacpe
vim.keymap.set("n", "<leader><space>", "<cmd>w<cr>") -- save
vim.keymap.set("n", "<leader>qq", "<cmd>q!<cr>") -- quick quit
-- toggle highlight search
vim.keymap.set(
  "n",
  "<leader>/",
  [[ (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n" <BAR> redraw<CR>]],
  { silent = true, expr = true, desc = "toggles highlighting" }
)
