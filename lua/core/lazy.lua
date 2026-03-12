-- =============================================================================
-- core/lazy.lua — Bootstrap lazy.nvim and load all plugins
-- =============================================================================
-- lazy.nvim is the plugin manager. It auto-installs itself on first launch,
-- then loads every file found inside lua/plugins/.
--
-- To add a plugin:  create a new file in lua/plugins/ (or add a spec to an
--                   existing one) and restart Neovim.
-- To update:        run  :Lazy update
-- To check status:  run  :Lazy
-- =============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Auto-install lazy.nvim if it isn't already present
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Load every lua/plugins/*.lua file as a plugin spec
  spec = { { import = "plugins" } },

  -- ── lazy.nvim options ──────────────────────────────────────────────────────
  defaults = {
    lazy = false, -- Load plugins at startup by default; individual plugins
  }, -- can override with  lazy = true
  install = {
    colorscheme = { "solarized", "habamax" }, -- Fallback themes during install
  },
  checker = {
    enabled = true, -- Periodically check for plugin updates
    notify = false, -- Don't notify unless you run :Lazy
  },
  change_detection = {
    notify = false, -- Don't notify on config file changes
  },
  ui = {
    border = "rounded",
  },
})

-- Keymap to open the lazy UI
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Open Lazy plugin manager" })
