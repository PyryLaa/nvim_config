-- =============================================================================
-- plugins/ui.lua — UI enhancements
-- =============================================================================
-- Contains: lualine (statusline), bufferline, indent-blankline, noice,
--           nvim-notify, dressing, and web-devicons.
-- =============================================================================

return {

  -- ── Statusline ─────────────────────────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "solarized",
        globalstatus = true,
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } }, -- Relative path
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- ── Buffer tabs ────────────────────────────────────────────────────────────
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        offsets = {
          { filetype = "NvimTree", text = "File Explorer", padding = 1 },
        },
      },
    },
  },

  -- ── Indent guides ──────────────────────────────────────────────────────────
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope = { enabled = true },
    },
  },

  -- ── Icons (required by many plugins) ──────────────────────────────────────
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- ── Better vim.ui.select / vim.ui.input ───────────────────────────────────
  {
    "stevearc/dressing.nvim",
    opts = {},
  },

  -- ── Which-key: shows keybind hints ────────────────────────────────────────
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = { delay = 500 },
  },
}
