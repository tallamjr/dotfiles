-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
  "github/copilot.vim",

  config = function()
    -- Disable default Copilot tab mapping
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_enabled = false -- Start with Copilot disabled

    -- Remap <Tab> to accept Copilot suggestions only
    vim.api.nvim_set_keymap("i", "<Tab>", "copilot#Accept('<Tab>')", { silent = true, expr = true, noremap = true })
    vim.api.nvim_set_keymap("i", "<S-Tab>", "<C-v><Tab>", { noremap = true, silent = true }) -- Prevent Shift-Tab from inserting tabs

    -- Create a key binding to toggle Copilot on and off
    vim.api.nvim_set_keymap(
      "n",
      "<leader>cp",
      ":lua vim.g.copilot_enabled = not vim.g.copilot_enabled<CR>",
      { noremap = true, silent = true }
    )

    -- Override <Tab> behavior for LaTeX files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "tex" },
      callback = function()
        vim.api.nvim_buf_set_keymap(
          0,
          "i",
          "<Tab>",
          "copilot#Accept('<Tab>')",
          { silent = true, expr = true, noremap = true }
        )
      end,
    })

    -- Optional: Configure nvim-cmp (or other autocompletion plugin) to not use Tab
    local cmp = require "cmp"
    cmp.setup {
      mapping = {
        -- Remove Tab mappings for navigating the completion menu
        ["<Tab>"] = function(fallback)
          fallback() -- Do nothing, fallback to default behavior (e.g., indenting)
        end,
        ["<S-Tab>"] = function(fallback)
          fallback() -- Do nothing, fallback to default behavior
        end,
      },
    }

    -- Disable Copilot for markdown files
    vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
      pattern = { "*.md", "*.markdown" },
      callback = function() vim.b.copilot_enabled = false end,
    })
  end,
}
