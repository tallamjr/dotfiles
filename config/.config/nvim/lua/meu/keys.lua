local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "kj", "<ESC>", { desc = "Exit insert mode with kj" })

-- increment/decrement numbers
keymap.set("n", "<leader>qq", "<cmd>q!<cr>", { desc = "Quick-quit" }) -- close file
keymap.set("n", "<leader>qa", "<cmd>qa<cr>", { desc = "Quick-quit" }) -- close file
keymap.set("n", "<leader><space>", "<cmd>w<cr>", { desc = "Save file" }) -- save file

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Function to open a file with the system's default application
local function open_with_system(file_path)
  local cmd = vim.fn.has "mac" == 1 and "open" or "xdg-open"
  vim.fn.jobstart({ cmd, file_path }, { detach = true })
end

-- Function to resolve a path (handles ~, relative paths, etc.)
local function resolve_path(path)
  -- Expand ~ to home directory
  path = vim.fn.expand(path)
  -- If not absolute, resolve relative to current buffer's directory
  if not path:match "^/" then
    local buf_dir = vim.fn.expand "%:p:h"
    path = buf_dir .. "/" .. path
  end
  -- Normalise the path (resolve . and ..)
  return vim.fn.fnamemodify(path, ":p")
end

-- Function to handle file://, PDF files, and URLs under cursor
local function open_file_under_cursor()
  local word = vim.fn.expand "<cWORD>"

  -- Strip common surrounding punctuation (quotes, parens, brackets, backticks)
  local cleaned = word:gsub("^[\"'`%(%[{<]+", ""):gsub("[\"'`%)%]}>]+$", "")

  -- Check for file:// URI
  local file_path
  if cleaned:match "^file://" then
    file_path = cleaned:gsub("^file://", "")
  -- Check if it ends with .pdf (case insensitive)
  elseif cleaned:lower():match "%.pdf$" then
    file_path = cleaned
  end

  -- If we identified a PDF path, try to open it
  if file_path and file_path:lower():match "%.pdf$" then
    local resolved = resolve_path(file_path)
    if vim.fn.filereadable(resolved) == 1 then
      open_with_system(resolved)
      vim.notify("Opening PDF: " .. vim.fn.fnamemodify(resolved, ":t"), vim.log.levels.INFO)
    else
      vim.notify("PDF not found: " .. resolved, vim.log.levels.ERROR)
    end
    return
  end

  -- Handle non-PDF file:// URIs (open in Neovim)
  if cleaned:match "^file://" then
    local path = cleaned:gsub("^file://", "")
    path = vim.fn.expand(path)
    vim.cmd("e " .. vim.fn.fnameescape(path))
    return
  end

  -- Fallback to the URL handler for web links and other content
  vim.cmd "URLOpenUnderCursor"
end

-- Key mapping to handle file:// links
vim.keymap.set("n", "<leader>o", open_file_under_cursor, { desc = "Open file or URL under cursor" })

keymap.set("n", "<leader>coe", "<cmd>Copilot enable<cr>", { desc = "Enable Copilot" }) --  enable copilot
keymap.set("n", "<leader>cod", "<cmd>Copilot disable<cr>", { desc = "Disable Copilot" }) --  disable copilot

-- Fighting one-eyed Kirby
keymap.set("v", "<localleader>r", [[:s/\(\w.*\)/]], { noremap = true, silent = false })

-- Unmap "\" from any normal mode mappings
vim.api.nvim_set_keymap("n", "\\", "<NOP>", { noremap = true, silent = true })

-- NOTE: theprimeagen/remap.lua

-- greatest remap ever
keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
keymap.set({ "n", "v" }, "<leader>y", [["+y]])
keymap.set("n", "<leader>Y", [["+Y]])

keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
keymap.set("i", "<C-c>", "<Esc>")

keymap.set("n", "Q", "<nop>")
keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
keymap.set("n", "<leader>f", vim.lsp.buf.format)

keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
keymap.set("n", "<leader>+x", "<cmd>!chmod +x %<CR>", { silent = true })

keymap.set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")
-------------------------------------------------------------------------------
