-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
  "serenevoid/kiwi.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    {
      name = "work",
      path = "/Users/tallam/tmp/wiki_1",
    },
    {
      name = "personal",
      path = "/Users/tallam/tmp/wiki_2",
    },
  },
  keys = {
    { "<leader>k", ':lua require("kiwi").open_wiki_index()<cr>', desc = "Open Wiki index" },
    { "<leader>kp", ':lua require("kiwi").open_wiki_index("personal")<cr>', desc = "Open index of personal wiki" },
    { "K", ':lua require("kiwi").todo.toggle()<cr>', desc = "Toggle Markdown Task" },
  },
  lazy = false,
}
