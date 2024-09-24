-- TODO:
--
vim.api.nvim_set_keymap("v", "<leader>fmt", ":!fmt -1000<CR>", { noremap = true, silent = true })

-- For init.lua (Lua-based configuration)
vim.api.nvim_set_keymap("n", "<leader>con", ":lua ToggleConceal()<CR>", { noremap = true, silent = true })

function ToggleConceal()
  local current_level = vim.wo.conceallevel
  if current_level == 0 then
    vim.wo.conceallevel = 2
  else
    vim.wo.conceallevel = 0
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt.spell = true
    vim.opt.spelllang = { "en_gb", "es", "pt" }
  end,
})
