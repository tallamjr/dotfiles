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

-- abbreviations
keymap.set("ia", "WQ", "wq")
keymap.set("ia", "teh", "the")
keymap.set("ia", "sun", "Sun")
keymap.set("ia", "universe", "Universe")
keymap.set("ia", "eqaution", "equation")
-- emoji shortcuts
keymap.set("ia", ":bomb:", "💣")
keymap.set("ia", ":book:", "📖")
keymap.set("ia", ":bulb:", "💡")
keymap.set("ia", ":grimm:", "😬")
keymap.set("ia", ":computer:", "💻")
keymap.set("ia", ":email:", "📧")
keymap.set("ia", ":happy_face:", "🙂")
keymap.set("ia", ":info:", "ℹ️")
keymap.set("ia", ":link:", "🔗")
keymap.set("ia", ":nerd_face:", "🤓")
keymap.set("ia", ":pencil:", "✏️")
keymap.set("ia", ":pill:", "💊")
keymap.set("ia", ":point_right:", "👉🏼")
keymap.set("ia", ":point_down:", "👇🏼")
keymap.set("ia", ":point_up:", "👆🏼")
keymap.set("ia", ":point_left:", "👈🏼")
keymap.set("ia", ":pushpin:", "📍")
keymap.set("ia", ":sad_face:", "☹️")
keymap.set("ia", ":see_no_evil:", "🙈")
keymap.set("ia", ":sweat:", "😅")
keymap.set("ia", ":telephone:", "☎️")
keymap.set("ia", ":telescope:", "🔭")
keymap.set("ia", ":tick:", "✅")
keymap.set("ia", ":thumbsup:", "👍🏼")
keymap.set("ia", ":warning:", "⚠️")
keymap.set("ia", ":wip:", "🚧")
keymap.set("ia", ":wrench:", "🔧")
keymap.set("ia", ":writing:", "🏼")
keymap.set("ia", ":x:", "❌")
keymap.set("ia", ":??:", "❔")
