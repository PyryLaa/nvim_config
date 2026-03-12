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
    },
  },
}
