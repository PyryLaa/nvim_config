return {
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      backends = { "lsp", "treesitter", "markdown", "man" },
      layout = {
        min_width = 28,
        default_direction = "prefer_right",
      },
      attach_mode = "window",
      show_guides = true,
    },
    keys = {
      { "{", "<cmd>AerialPrev<cr>", desc = "Prev symbol" },
      { "}", "<cmd>AerialNext<cr>", desc = "Next symbol" },
    },
  },
}
