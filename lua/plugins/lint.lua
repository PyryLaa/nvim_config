-- =============================================================================
-- plugins/lint.lua — Code linting (nvim-lint + ruff)
-- =============================================================================
-- nvim-lint runs linters asynchronously and pushes results into Neovim's
-- built-in diagnostic system (same as LSP errors).
--
-- Ruff is used for Python linting (replaces flake8, pylint, etc.).
-- Mypy is also wired in for optional static type checking.
--
-- Keymap:
--   <leader>cl  — Manually trigger linting on the current buffer
--
-- To disable a linter for Python, remove it from the python table below.
-- To add a linter for another filetype, add an entry to `linters_by_ft`.
-- Full linter list: https://github.com/mfussenegger/nvim-lint#available-linters
-- =============================================================================

return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "InsertLeave" },
    keys = {
      {
        "<leader>cl",
        function()
          require("lint").try_lint()
        end,
        desc = "Trigger linting",
      },
    },
    config = function()
      local lint = require("lint")

      -- ── Linters per filetype ───────────────────────────────────────────────
      lint.linters_by_ft = {
        python = { "ruff" },
        -- Uncomment to also run mypy for type errors:
        -- python = { "ruff", "mypy" },
        -- Add more, e.g.:
        -- javascript = { "eslint_d" },
      }

      -- ── Ruff linter configuration ─────────────────────────────────────────
      -- You can also configure ruff via a pyproject.toml or ruff.toml in your
      -- project root — that is the recommended approach.
      lint.linters.ruff = vim.tbl_extend("force", lint.linters.ruff or {}, {
        args = {
          "check",
          "--select",
          "E,F,W,I,UP,B,A,C4,SIM", -- Rule sets to enable
          -- "ALL" enables every rule — usually too noisy
          "--output-format",
          "json",
          "-", -- Read from stdin
        },
      })

      -- ── Auto-lint on relevant events ──────────────────────────────────────
      local augroup = vim.api.nvim_create_augroup("NvimLint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
        group = augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
