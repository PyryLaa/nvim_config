-- =============================================================================
-- plugins/python.lua — Python-specific tooling
-- =============================================================================
-- Contains:
--   nvim-dap        — Debug Adapter Protocol (breakpoints, step-through, etc.)
--   nvim-dap-python — Python debug adapter (uses debugpy)
--   nvim-dap-ui     — UI panels for debugging
--   venv-selector   — Switch between Python virtual environments
--
-- Debug keymaps:
--   <leader>db   — Toggle breakpoint
--   <leader>dB   — Set conditional breakpoint
--   <leader>dc   — Continue / start debugging
--   <leader>di   — Step into
--   <leader>do   — Step over
--   <leader>dO   — Step out
--   <leader>dr   — Open REPL
--   <leader>du   — Toggle DAP UI
--   <leader>dt   — Terminate debug session
--
-- Venv selector:
--   <leader>vs   — Open venv selector
-- =============================================================================

return {

  -- ── DAP core ──────────────────────────────────────────────────────────────
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end,                                    desc = "DAP: toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end,           desc = "DAP: conditional breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,                                            desc = "DAP: continue" },
      { "<leader>di", function() require("dap").step_into() end,                                           desc = "DAP: step into" },
      { "<leader>do", function() require("dap").step_over() end,                                           desc = "DAP: step over" },
      { "<leader>dO", function() require("dap").step_out() end,                                            desc = "DAP: step out" },
      { "<leader>dr", function() require("dap").repl.open() end,                                           desc = "DAP: open REPL" },
      { "<leader>dt", function() require("dap").terminate() end,                                           desc = "DAP: terminate" },
    },
  },

  -- ── Python DAP adapter ────────────────────────────────────────────────────
  -- Requires debugpy: pip install debugpy
  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = "python",
    config = function()
      -- Uses the python from the active virtual env, or falls back to system python3
      local python = vim.fn.exepath("python3") or "python3"

      -- If using mason-installed debugpy:
      local mason_python = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      if vim.fn.filereadable(mason_python) == 1 then
        python = mason_python
      end

      require("dap-python").setup(python)

      -- Extra keymaps for Python-specific DAP methods
      vim.keymap.set("n", "<leader>dm", function()
        require("dap-python").test_method()
      end, { desc = "DAP: test method" })

      vim.keymap.set("n", "<leader>dC", function()
        require("dap-python").test_class()
      end, { desc = "DAP: test class" })
    end,
  },

  -- ── DAP UI ────────────────────────────────────────────────────────────────
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    keys = {
      { "<leader>du", function() require("dapui").toggle() end, desc = "DAP: toggle UI" },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      -- Auto-open/close UI when a debug session starts/ends
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"]     = function() dapui.close() end
    end,
  },

  -- ── Virtual environment selector ──────────────────────────────────────────
  -- Automatically detects .venv, venv, .virtualenv, conda envs, etc.
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    ft = "python",
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>",       desc = "Select Python venv" },
      { "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "Use cached Python venv" },
    },
    opts = {
      auto_refresh = true,
    },
  },
}
