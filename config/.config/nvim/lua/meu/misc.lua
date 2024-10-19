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

-- Automatically trigger code actions for missing imports on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)

    for _, res in pairs(result or {}) do
      for _, action in pairs(res.result or {}) do
        if action.edit or type(action.command) == "table" then
          if action.kind == "quickfix" then vim.lsp.buf.execute_command(action.command) end
        end
      end
    end
  end,
})

-- Function to remove trailing whitespace
local function strip_trailing_whitespace()
  local pos = vim.api.nvim_win_get_cursor(0) -- Save the current cursor position
  vim.cmd [[%s/\s\+$//e]] -- Strip trailing whitespace
  vim.api.nvim_win_set_cursor(0, pos) -- Restore the cursor position
end

-- Automatically strip whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = strip_trailing_whitespace,
})

-- Build latex documents
vim.api.nvim_set_keymap(
  "n",
  "<leader>lm",
  ":w<CR>"
    .. ":!biber %<CR>"
    .. ":!latexmk -pdflatex=lualatex -pdf -file-line-error -halt-on-error -interaction=nonstopmode -shell-escape %<CR>"
    .. ":!open %:r.pdf<CR>",
  { noremap = true, silent = true }
)
