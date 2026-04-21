-- =============================================================================
-- plugins/format.lua — Code formatting (conform.nvim + ruff)
-- =============================================================================
-- conform.nvim runs formatters on save (or on demand).
-- Ruff is used for Python formatting (it replaces black + isort).
--
-- Keymaps:
--   <leader>cf  — Format current buffer (normal or visual mode)
--   <leader>tf  — Toggle format-on-save
--
-- To disable format-on-save permanently, set `format_on_save = false` below.
-- To add a formatter for another filetype, add an entry to `formatters_by_ft`.
-- Full formatter list: https://github.com/stevearc/conform.nvim#formatters
-- =============================================================================

return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    opts = {
      -- ── Formatters per filetype ────────────────────────────────────────────
      -- For Python we use ruff for both formatting (ruff-format) and import
      -- sorting (ruff organise-imports).  Install with: pip install ruff
      -- or: mason will install it when listed in mason-tool-installer below.
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
        python = { "ruff_format", "ruff_organize_imports" },
        lua = { "stylua" },
        sh = { "shfmt" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        -- Add more here: e.g.  javascript = { "prettier" }
      },

      -- ── Format on save ────────────────────────────────────────────────────
      -- Set to false, or press <leader>tf to toggle off
      format_on_save = function(bufnr)
        -- Respect a buffer-local disable flag (set by <leader>tf toggle)
        if vim.b[bufnr].disable_autoformat or vim.g.disable_autoformat then
          return
        end
        return { timeout_ms = 1500, lsp_fallback = true }
      end,

      -- ── Formatter config overrides ────────────────────────────────────────
      formatters = {
        ruff_format = {
          -- Extra args passed to  ruff format.
          -- To change line length: prepend_args = { "--line-length", "100" }
          prepend_args = {},
        },
        ruff_organize_imports = {
          prepend_args = {},
        },
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)

      -- Toggle format-on-save
      vim.keymap.set("n", "<leader>tf", function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        vim.notify("Format on save: " .. (vim.g.disable_autoformat and "OFF" or "ON"), vim.log.levels.INFO)
      end, { desc = "Toggle format on save" })
    end,
  },

  -- ── mason-tool-installer: auto-install formatters & linters ───────────────
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        -- LSP servers (Mason package names; configured in lsp.lua)
        "clangd", -- C/C++ LSP
        "pyright", -- Python LSP
        "lua-language-server", -- Lua LSP
        "bash-language-server", -- Bash LSP
        "json-lsp", -- JSON LSP
        "yaml-language-server", -- YAML LSP
        -- Linters & formatters
        "ruff", -- Python linter + formatter
        "stylua", -- Lua formatter
        "shfmt", -- Shell formatter
        "prettier", -- JSON/YAML/Markdown formatter
      },
      auto_update = false,
    },
  },
}
