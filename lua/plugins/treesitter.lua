-- =============================================================================
-- plugins/treesitter.lua — Syntax highlighting & code understanding
-- =============================================================================
-- Treesitter provides:
--   • Accurate, fast syntax highlighting
--   • Smart text objects  (select inside function, class, etc.)
--   • Incremental selection
--   • Auto-closing pairs via nvim-autopairs
--
-- To add more languages, add them to the `ensure_installed` list.
-- Full list: https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
-- =============================================================================

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",  -- Extra text objects
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "python", "lua", "vim", "vimdoc",
          "bash", "json", "yaml", "toml",
          "markdown", "markdown_inline",
          "html", "css",
        },
        auto_install     = true,   -- Install missing parsers automatically
        highlight        = { enable = true },
        indent           = { enable = true },

        -- ── Incremental selection ────────────────────────────────────────────
        incremental_selection = {
          enable  = true,
          keymaps = {
            init_selection    = "<C-space>",
            node_incremental  = "<C-space>",
            scope_incremental = "<C-s>",
            node_decremental  = "<bs>",
          },
        },

        -- ── Textobjects (requires nvim-treesitter-textobjects) ───────────────
        textobjects = {
          select = {
            enable    = true,
            lookahead = true,   -- Automatically jump to next textobject
            keymaps = {
              -- Python-friendly objects
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["al"] = "@loop.outer",
              ["il"] = "@loop.inner",
            },
          },
          move = {
            enable              = true,
            set_jumps           = true,
            goto_next_start     = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
            goto_next_end       = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
            goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
            goto_previous_end   = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
          },
          swap = {
            enable = true,
            swap_next     = { ["<leader>sn"] = "@parameter.inner" },
            swap_previous = { ["<leader>sp"] = "@parameter.inner" },
          },
        },
      })
    end,
  },

  -- ── Auto-close brackets/quotes ─────────────────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts  = { check_ts = true },   -- Use treesitter to avoid pairing in comments
  },
}
