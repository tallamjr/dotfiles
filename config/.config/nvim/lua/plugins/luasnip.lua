return {
  "L3MON4D3/LuaSnip",
  config = function(plugin, opts)
    -- include the default astronvim config that calls the setup call
    require "astronvim.plugins.configs.luasnip"(plugin, opts)
    local luasnip = require "luasnip"
    luasnip.filetype_extend("javascript", { "javascriptreact" })
    -- Create a LuaSnip snippet for gitcommit filetype
    -- luasnip.add_snippets("gitcommit", {
    --   luasnip.snippet("cc", {
    --     -- Prompt for the type of change
    --     luasnip.choice_node(1, {
    --       luasnip.text_node "feat", -- New feature
    --       luasnip.text_node "fix", -- Bug fix
    --       luasnip.text_node "docs", -- Documentation changes
    --       luasnip.text_node "style", -- Code style changes (formatting, missing semicolons, etc.)
    --       luasnip.text_node "refactor", -- Refactoring code
    --       luasnip.text_node "perf", -- Performance improvements
    --       luasnip.text_node "test", -- Adding or fixing tests
    --       luasnip.text_node "chore", -- Other changes that don't modify src or test files
    --     }),
    --     luasnip.text_node "(",
    --     -- Prompt for the scope (optional)
    --     luasnip.insert_node(2, "scope"),
    --     luasnip.text_node "): ",
    --     -- Prompt for the short description
    --     luasnip.insert_node(3, "short description"),
    --     luasnip.text_node { "", "", "" }, -- New lines
    --     -- Prompt for the detailed description (optional)
    --     luasnip.insert_node(4, "long description (optional)"),
    --     luasnip.text_node { "", "", "" }, -- New lines
    --     -- Prompt for closing keywords (optional)
    --     luasnip.insert_node(5, "closes/fixes (optional)"),
    --   }),
    --   -- Use Tab to expand or jump in a snippet
    --   vim.api.nvim_set_keymap(
    --     "i",
    --     "<Tab>",
    --     [[luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>']],
    --     { expr = true, silent = true }
    --   ),
    --
    --   -- Use Shift-Tab to jump backwards in a snippet
    --   vim.api.nvim_set_keymap("i", "<S-Tab>", [[<cmd>lua require('luasnip').jump(-1)<CR>]], { silent = true }),
    --
    --   -- For selection in choice nodes
    --   vim.api.nvim_set_keymap(
    --     "i",
    --     "<C-E>",
    --     [[<cmd>lua require('luasnip.extras.select_choice')()<CR>]],
    --     { noremap = true, silent = true }
    --   ),
    -- })
    -- load snippets paths
    -- require("luasnip.loaders.from_vscode").lazy_load {
    require("luasnip.loaders.from_snipmate").load {
      paths = { "~/.config/nvim/snippets" },
    }
  end,
}
