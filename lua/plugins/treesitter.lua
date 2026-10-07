return {
  -- ── Auto-close brackets/quotes ─────────────────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = { check_ts = false }, -- no nvim-treesitter to integrate with
  },
}
