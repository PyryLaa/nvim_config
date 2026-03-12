-- =============================================================================
-- plugins/colorscheme.lua — Colour scheme
-- =============================================================================
-- To swap to a different theme entirely, replace this file's return value with
-- any other plugin spec, e.g. tokyonight, kanagawa, gruvbox, etc.
-- =============================================================================

return {
  {
    "ribru17/bamboo.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("bamboo").setup({
        -- optional configuration here
      })
      require("bamboo").load()
    end,
  },
}
