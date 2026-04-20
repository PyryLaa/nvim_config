-- =============================================================================
-- Copilot integration for neovim
-- =============================================================================
-- =============================================================================

return {
  {
    -- copilot itself
    "github/copilot.vim",
  },
  {
    -- copilot chat
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    opts = {
      -- See Configuration section for options
      model = "claude-sonnet-4.5",
    },
    keys = {
      { "<leader>cc", "<cmd>CopilotChat<cr>", desc = "Open Copilot Chat" },
      { "<leader>cr", "<cmd>CopilotChatReset<cr>", desc = "Reset Copilot Chat" },
      { "<leader>cm", "<cmd>CopilotChatModels<cr>", desc = "Select CopilotChat model" },
      { "<leader>ccq", "<cmd>CopilotChatClose<cr>", desc = "Close Copilot Chat" },
    },
  },
}
