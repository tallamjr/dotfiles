-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {

  { -- requires plugins in lua/plugins/treesitter.lua and lua/plugins/lsp.lua
    -- for complete functionality (language features)
    "quarto-dev/quarto-nvim",
    dev = false,
    opts = {
      lspFeatures = {
        enabled = true,
        documentSymbols = false, -- ← disable outline requests
        chunks = "curly",
      },
      codeRunner = {
        enabled = true,
        default_method = "slime",
      },
    },
    dependencies = {
      -- for language features in code cells
      -- configured in lua/plugins/lsp.lua
      "jmbuhr/otter.nvim",
    },
    -- ─────────────────────────────────────────────────────────────────────────────
    -- Add this config to wire up the runner keymaps:
    config = function(_, opts)
      -- 1) let quarto-nvim apply your opts
      require("quarto").setup(opts)

      -- 2) grab the runner interface
      local runner = require "quarto.runner"

      -- 3) map your favourite keys under <localleader> (= '\')
      vim.keymap.set("n", "<localleader>rc", runner.run_cell, {
        desc = " Run current Quarto cell",
        silent = true,
      })
      vim.keymap.set("n", "<localleader>ra", runner.run_above, {
        desc = " Run this and all above",
        silent = true,
      })
      vim.keymap.set("n", "<localleader>rb", runner.run_below, {
        desc = " Run this and all below",
        silent = true,
      })
      vim.keymap.set("n", "<localleader>rA", runner.run_all, {
        desc = " Run all cells",
        silent = true,
      })
      vim.keymap.set("n", "<localleader>rl", runner.run_line, {
        desc = " Run current line",
        silent = true,
      })
      vim.keymap.set("v", "<localleader>r", runner.run_range, {
        desc = " Run visual selection",
        silent = true,
      })
    end,
  },

  { -- directly open ipynb files as quarto docuements
    "GCBallesteros/jupytext.nvim",
    opts = {
      custom_language_formatting = {
        python = {
          extension = "qmd",
          style = "quarto",
          force_ft = "quarto",
        },
        r = {
          extension = "qmd",
          style = "quarto",
          force_ft = "quarto",
        },
      },
    },
  },

  { -- send code from python/R/qmd docs to a tmux REPL pane
    "jpalardy/vim-slime",
    dev = false,
    init = function()
      -- Quarto chunk detection & ipython override
      vim.b["quarto_is_python_chunk"] = false
      Quarto_is_in_python_chunk = function() require("otter.tools.functions").is_otter_language_context "python" end

      vim.cmd [[
      let g:slime_dispatch_ipython_pause = 100
      function SlimeOverride_EscapeText_quarto(text)
        call v:lua.Quarto_is_in_python_chunk()
        if exists('g:slime_python_ipython')
          \ && len(split(a:text, "\n")) > 1
          \ && b:quarto_is_python_chunk
          \ && !(exists('b:quarto_is_r_mode') && b:quarto_is_r_mode)
          return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, a:text, "--\n"]
        endif
        return [a:text]
      endfunction
      ]]

      -- neovim-rpc target
      vim.g.slime_target = "neovim"
      vim.g.slime_no_mappings = true
      vim.g.slime_python_ipython = 1

      vim.g.slime_bracketed_paste = true
      vim.g.slime_python_ipython = 1
      vim.g.slime_no_mappings = true
    end,
    config = function()
      vim.g.slime_suggest_default = true
      vim.g.slime_menu_config = false
      vim.g.slime_input_pid = false
      vim.g.slime_neovim_ignore_unlisted = true
    end,
  },

  { -- paste an image from the clipboard or drag-and-drop
    "HakonHarnes/img-clip.nvim",
    event = "BufEnter",
    ft = { "markdown", "quarto", "latex" },
    opts = {
      default = { dir_path = "img" },
      filetypes = {
        markdown = {
          url_encode_path = true,
          template = "![$CURSOR]($FILE_PATH)",
          drag_and_drop = { download_images = false },
        },
        quarto = {
          url_encode_path = true,
          template = "![$CURSOR]($FILE_PATH)",
          drag_and_drop = { download_images = false },
        },
      },
    },
    config = function(_, opts)
      require("img-clip").setup(opts)
      vim.keymap.set("n", "<leader>ii", ":PasteImage<cr>", { desc = "insert [i]mage from clipboard" })
    end,
  },

  { -- preview equations
    "jbyuki/nabla.nvim",
    keys = {
      { "<leader>qm", ':lua require"nabla".toggle_virt()<cr>', desc = "toggle [m]ath equations" },
    },
  },

  {
    "benlubas/molten-nvim",
    dev = false,
    enabled = true,
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_auto_open_output = true
      vim.g.molten_auto_open_html_in_browser = true
      vim.g.molten_tick_rate = 200
    end,
    config = function()
      local init = function()
        local quarto_cfg = require("quarto.config").config
        quarto_cfg.codeRunner.default_method = "molten"
        vim.cmd [[MoltenInit]]
      end
      local deinit = function()
        local quarto_cfg = require("quarto.config").config
        quarto_cfg.codeRunner.default_method = "slime"
        vim.cmd [[MoltenDeinit]]
      end
      vim.keymap.set("n", "<localleader>mi", init, { silent = true, desc = "Initialize molten" })
      vim.keymap.set("n", "<localleader>md", deinit, { silent = true, desc = "Stop molten" })
      vim.keymap.set("n", "<localleader>mp", ":MoltenImagePopup<CR>", { silent = true, desc = "molten image popup" })
      vim.keymap.set(
        "n",
        "<localleader>mb",
        ":MoltenOpenInBrowser<CR>",
        { silent = true, desc = "molten open in browser" }
      )
      vim.keymap.set("n", "<localleader>mh", ":MoltenHideOutput<CR>", { silent = true, desc = "hide output" })
      vim.keymap.set(
        "n",
        "<localleader>ms",
        ":noautocmd MoltenEnterOutput<CR>",
        { silent = true, desc = "show/enter output" }
      )
    end,
  },
}
