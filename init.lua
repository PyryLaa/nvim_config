-- =============================================================================
-- init.lua — Neovim entry point
-- =============================================================================
-- All configuration is split into modules under lua/core/ and lua/plugins/.
-- Load order matters: options → keymaps → autocmds → lazy (plugin manager).
-- =============================================================================

require("core.options") -- Editor options (line numbers, tabs, etc.)
require("core.keymaps") -- Global key mappings (non-plugin)
require("core.autocmds") -- Auto commands (format on save, highlight yank, etc.)
require("core.lazy") -- Plugin manager bootstrap + plugin loading
require("aerial").setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
