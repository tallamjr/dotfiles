return {
  {
    "KabbAmine/lazyList.vim",
    event = "VeryLazy", -- Lazy load the plugin
    config = function()
      -- Your custom key mappings
      vim.api.nvim_set_keymap("n", "gll", ":LazyList<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("v", "gll", ":LazyList<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "gl-", ":LazyList '- '<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("v", "gl-", ":LazyList '- '<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "gl1", ":LazyList '%1%. '<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("v", "gl1", ":LazyList '%1%. '<CR>", { noremap = true, silent = true })
    end,
  },
}
