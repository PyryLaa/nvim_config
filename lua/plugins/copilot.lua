-- =============================================================================
-- Copilot integration for neovim
-- =============================================================================
-- =============================================================================

return {
  {
    -- copilot itself
    "github/copilot.vim",
    keys = {
      { "<leader>cd", "<cmd>Copilot disable<cr>", desc = "Disable Copilot" },
      { "<leader>ce", "<cmd>Copilot enable<cr>", desc = "Enable Copilot" },
    },
  },
  {
    -- copilot chat
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    config = function()
      require("CopilotChat").setup({
        -- See Configuration section for options
        model = "claude-opus-5.5",
        trusted_tools = { "file", "grep", "glob" },
        sticky = { "#buffer", "@copilot" },
      })

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
          vim.opt_local.conceallevel = 0
        end,
      })
    end,
    keys = {
      { "<leader>cc", "<cmd>CopilotChat<cr>", desc = "Open Copilot Chat" },
      { "<leader>cr", "<cmd>CopilotChatReset<cr>", desc = "Reset Copilot Chat" },
      { "<leader>cm", "<cmd>CopilotChatModels<cr>", desc = "Select CopilotChat model" },
      { "<leader>ccq", "<cmd>CopilotChatClose<cr>", desc = "Close Copilot Chat" },
    },
  },
}
