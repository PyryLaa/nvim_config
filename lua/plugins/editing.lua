-- =============================================================================
-- plugins/editing.lua — Quality-of-life editing plugins
-- =============================================================================
-- Contains:
--   vim-surround    — Add/change/delete surrounding brackets, quotes, tags
--   Comment.nvim    — Toggle comments
--   todo-comments   — Highlight TODO/FIXME/NOTE/HACK/WARN in code
--   trouble.nvim    — Pretty diagnostics / quickfix panel
--   nvim-spectre    — Project-wide find & replace
-- =============================================================================

return {

  -- ── Surround: add/change/delete surroundings ──────────────────────────────
  -- Examples:
  --   ysiw"    — Surround word with "
  --   cs"'     — Change surrounding " to '
  --   ds"      — Delete surrounding "
  --   yss)     — Surround entire line with ()
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- ── Toggle comments ────────────────────────────────────────────────────────
  -- Normal mode:  gcc  — toggle line comment
  -- Visual mode:  gc   — toggle comment on selection
  -- Normal mode:  gcap — comment a paragraph
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- ── Trouble: pretty diagnostics panel ────────────────────────────────────
  -- <leader>xx — Toggle diagnostics panel
  -- <leader>xd — Document diagnostics
  -- <leader>xw — Workspace diagnostics
  -- <leader>xl — Location list
  -- <leader>xq — Quickfix list
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "Trouble: toggle" },
      { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Trouble: document" },
      { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Trouble: workspace" },
      { "<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "Trouble: loclist" },
      { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc = "Trouble: quickfix" },
    },
    opts = { use_diagnostic_signs = true },
  },

  -- ── nvim-spectre: project-wide find & replace ─────────────────────────────
  -- <leader>S  — Open Spectre (find & replace across project)
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>S",
        function()
          require("spectre").open()
        end,
        desc = "Spectre: open",
      },
      {
        "<leader>Sw",
        function()
          require("spectre").open_visual({ select_word = true })
        end,
        desc = "Spectre: word",
      },
    },
    opts = {},
  },

  -- ── Flash: fast cursor motion ─────────────────────────────────────────────
  -- s       — Flash jump (type 2 chars to jump anywhere on screen)
  -- S       — Flash Treesitter jump (jump to a TS node)
  -- r (op)  — Remote flash (operate on a distant text object)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "x", "o" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter search",
      },
    },
  },
}
