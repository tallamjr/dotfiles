return {
  "jackMort/ChatGPT.nvim",
  event = "VeryLazy",
  config = function()
    -- Set up ChatGPT plugin with configuration
    require("chatgpt").setup {
      api_key_cmd = "pass show api/tokens/openai",
      openai_params = {
        model = "chatgpt-4o-latest",
        frequency_penalty = 0,
        presence_penalty = 0,
        max_tokens = 4095,
        temperature = 0.2,
        top_p = 0.1,
        n = 1,
      },
    }

    -- Add keybindings for ChatGPT functionalities
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>cc", "<cmd>ChatGPT<CR>", { desc = "ChatGPT" })
    keymap.set({ "n", "v" }, "<leader>ce", "<cmd>ChatGPTEditWithInstruction<CR>", { desc = "Edit with instruction" })
    keymap.set({ "n", "v" }, "<leader>cg", "<cmd>ChatGPTRun grammar_correction<CR>", { desc = "Grammar Correction" })
    keymap.set({ "n", "v" }, "<leader>ct", "<cmd>ChatGPTRun translate<CR>", { desc = "Translate" })
    keymap.set({ "n", "v" }, "<leader>ck", "<cmd>ChatGPTRun keywords<CR>", { desc = "Keywords" })
    keymap.set({ "n", "v" }, "<leader>cd", "<cmd>ChatGPTRun docstring<CR>", { desc = "Docstring" })
    keymap.set({ "n", "v" }, "<leader>ca", "<cmd>ChatGPTRun add_tests<CR>", { desc = "Add Tests" })
    keymap.set({ "n", "v" }, "<leader>co", "<cmd>ChatGPTRun optimize_code<CR>", { desc = "Optimize Code" })
    keymap.set({ "n", "v" }, "<leader>cs", "<cmd>ChatGPTRun summarize<CR>", { desc = "Summarize" })
    keymap.set({ "n", "v" }, "<leader>cf", "<cmd>ChatGPTRun fix_bugs<CR>", { desc = "Fix Bugs" })
    keymap.set({ "n", "v" }, "<leader>cx", "<cmd>ChatGPTRun explain_code<CR>", { desc = "Explain Code" })
    keymap.set({ "n", "v" }, "<leader>cr", "<cmd>ChatGPTRun roxygen_edit<CR>", { desc = "Roxygen Edit" })
    keymap.set(
      { "n", "v" },
      "<leader>cl",
      "<cmd>ChatGPTRun code_readability_analysis<CR>",
      { desc = "Code Readability Analysis" }
    )
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
}
