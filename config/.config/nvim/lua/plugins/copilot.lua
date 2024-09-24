-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
  "github/copilot.vim",

  config = function()
    -- Disable default Copilot tab mapping
    vim.g.copilot_no_tab_map = true

    -- Remap <Tab> to accept Copilot suggestions only
    vim.api.nvim_set_keymap("i", "<Tab>", "copilot#Accept('<Tab>')", { silent = true, expr = true })
    vim.api.nvim_set_keymap("i", "<S-Tab>", "<C-v><Tab>", { noremap = true, silent = true }) -- Prevent Shift-Tab from inserting tabs

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
