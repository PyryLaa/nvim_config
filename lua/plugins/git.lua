-- =============================================================================
-- plugins/git.lua — Git integration
-- =============================================================================
-- gitsigns  — Signs in the gutter, hunk operations, blame
-- lazygit   — Full-screen git UI  (requires lazygit to be installed)
--
-- Gitsigns keymaps:
--   ]h / [h         — Jump to next / prev hunk
--   <leader>hs      — Stage hunk
--   <leader>hr      — Reset hunk
--   <leader>hS      — Stage entire buffer
--   <leader>hR      — Reset entire buffer
--   <leader>hp      — Preview hunk diff
--   <leader>hb      — Blame current line
--   <leader>hd      — Diff this file vs index
--
-- LazyGit:
--   <leader>gg      — Open LazyGit
-- =============================================================================

return {
  -- ── Gutter signs + hunk operations ───────────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs  = package.loaded.gitsigns
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
        end

        -- Navigation
        map("n", "]h", gs.next_hunk, "Next hunk")
        map("n", "[h", gs.prev_hunk, "Prev hunk")

        -- Hunk operations
        map({ "n", "v" }, "<leader>hs", gs.stage_hunk,        "Stage hunk")
        map({ "n", "v" }, "<leader>hr", gs.reset_hunk,        "Reset hunk")
        map("n",          "<leader>hS", gs.stage_buffer,      "Stage buffer")
        map("n",          "<leader>hR", gs.reset_buffer,      "Reset buffer")
        map("n",          "<leader>hp", gs.preview_hunk,      "Preview hunk")
        map("n",          "<leader>hb", gs.blame_line,        "Blame line")
        map("n",          "<leader>hd", gs.diffthis,          "Diff this")
        map("n",          "<leader>hD", function() gs.diffthis("~") end, "Diff this ~")

        -- Text object: ih = inside hunk
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<cr>", "Select hunk")
      end,
    },
  },

  -- ── LazyGit TUI ───────────────────────────────────────────────────────────
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Open LazyGit" },
    },
    cmd = { "LazyGit" },
  },
}
