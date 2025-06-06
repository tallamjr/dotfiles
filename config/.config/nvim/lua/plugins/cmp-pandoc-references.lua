return {
  "jmbuhr/cmp-pandoc-references",
  ft = { "markdown", "rmd", "quarto" }, -- ← include 'quarto'
  dependencies = { "hrsh7th/nvim-cmp" },
  config = function()
    local cmp = require "cmp"
    cmp.setup.filetype({ "markdown", "rmd", "quarto" }, {
      sources = cmp.config.sources({
        { name = "pandoc_references" },
      }, {
        { name = "buffer" },
      }),
    })
  end,
}
