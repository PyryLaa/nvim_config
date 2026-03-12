-- =============================================================================
-- plugins/explorer.lua — File explorer (nvim-tree)
-- =============================================================================
-- Keymaps:
--   <leader>e  — Toggle the file tree
--   <leader>ef — Reveal the current file in the tree
--
-- Inside the tree window:
--   o / <CR>   — Open file / expand folder
--   a          — Create file or directory  (end with / to create a directory)
--   d          — Delete
--   r          — Rename
--   x          — Cut
--   c          — Copy
--   p          — Paste
--   y          — Copy filename
--   Y          — Copy relative path
--   H          — Toggle hidden files
--   ?          — Help
-- =============================================================================

return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e",  "<cmd>NvimTreeToggle<cr>",   desc = "Toggle file explorer" },
      { "<leader>ef", "<cmd>NvimTreeFindFile<cr>", desc = "Reveal file in explorer" },
    },
    opts = {
      hijack_netrw      = true,   -- Replace netrw with nvim-tree
      sync_root_with_cwd = true,
      view = {
        width = 35,
        side  = "left",
      },
      renderer = {
        group_empty = true,   -- Collapse empty folders into one line
        icons = {
          show = { git = true, file = true, folder = true, folder_arrow = true },
        },
      },
      filters = {
        dotfiles = false,   -- Show dotfiles by default; toggle with H
      },
      git = {
        enable  = true,
        ignore  = false,   -- Show git-ignored files (dimmed)
        timeout = 400,
      },
      actions = {
        open_file = {
          quit_on_open = false,   -- Keep tree open after opening a file
          window_picker = { enable = true },
        },
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
      },
    },
  },
}
