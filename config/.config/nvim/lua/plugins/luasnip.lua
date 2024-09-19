return {
  "L3MON4D3/LuaSnip",
  config = function(plugin, opts)
    -- include the default astronvim config that calls the setup call
    require "astronvim.plugins.configs.luasnip"(plugin, opts)
    local luasnip = require "luasnip"
    luasnip.filetype_extend("javascript", { "javascriptreact" })
    -- load snippets paths
    -- require("luasnip.loaders.from_vscode").lazy_load {
    require("luasnip.loaders.from_snipmate").load {
      paths = { "~/.config/nvim/snippets" },
    }
  end,
}
