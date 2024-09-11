return {
  -- nvim-dap core setup
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require "dap"
      local mason_registry = require "mason-registry"

      -- --------------------
      -- Python Adapter Setup
      -- --------------------
      dap.adapters.python = {
        type = "executable",
        command = "python", -- Adjust this if you have a specific Python version or virtualenv
        args = { "-m", "debugpy.adapter" }, -- Use debugpy for Python debugging
      }

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}", -- This will launch the current file
          pythonPath = function()
            return "python" -- You can modify this to use virtual environments or other versions
          end,
        },
      }

      -- --------------------
      -- Rust Adapter Setup (CodeLLDB)
      -- --------------------
      local codelldb_package = mason_registry.get_package "codelldb"
      local codelldb_path = codelldb_package:get_install_path() .. "/extension/adapter/codelldb"
      local liblldb_path = codelldb_package:get_install_path() .. "/extension/lldb/lib/liblldb.so" -- Adjust for macOS

      dap.adapters.lldb = {
        type = "server",
        port = "${port}", -- Dynamically assigned port for the DAP client
        executable = {
          command = codelldb_path, -- Path to codelldb installed via Mason
          args = { "--port", "${port}" }, -- Start codelldb on the dynamically assigned port
        },
        name = "lldb",
        env = {
          LLDB_LIBRARY_PATH = liblldb_path, -- Ensure LLDB library is correctly set
        },
      }

      dap.configurations.rust = {
        {
          name = "Launch Rust program",
          type = "lldb",
          request = "launch",
          program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file") end,
          cwd = "${workspaceFolder}", -- Set the current working directory
          stopOnEntry = false, -- Do not stop on entry
          args = {}, -- Additional arguments
        },
      }

      -- ----------------------
      -- Global Key Mappings for DAP
      -- ----------------------
      vim.fn.sign_define("DapBreakpoint", { text = "🧐", texthl = "", linehl = "", numhl = "" })

      -- Mappings to control the debugger
      vim.api.nvim_set_keymap("n", "<F5>", "<Cmd>lua require'dap'.continue()<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<F10>", "<Cmd>lua require'dap'.step_over()<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<F11>", "<Cmd>lua require'dap'.step_into()<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<F12>", "<Cmd>lua require'dap'.step_out()<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap(
        "n",
        "<leader>b",
        "<Cmd>lua require'dap'.toggle_breakpoint()<CR>",
        { noremap = true, silent = true }
      )
    end,
  },

  -- nvim-dap UI for better visualization
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dapui").setup()

      -- Automatically open DAP UI when DAP starts and close when DAP stops
      local dap, dapui = require "dap", require "dapui"
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
  },

  -- nvim-dap virtual text for inline variable values
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function() require("nvim-dap-virtual-text").setup() end,
  },
}
