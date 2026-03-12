-- =============================================================================
-- init.lua — Neovim entry point
-- =============================================================================
-- All configuration is split into modules under lua/core/ and lua/plugins/.
-- Load order matters: options → keymaps → autocmds → lazy (plugin manager).
-- =============================================================================

require("core.options")    -- Editor options (line numbers, tabs, etc.)
require("core.keymaps")    -- Global key mappings (non-plugin)
require("core.autocmds")   -- Auto commands (format on save, highlight yank, etc.)
require("core.lazy")       -- Plugin manager bootstrap + plugin loading
