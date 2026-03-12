-- =============================================================================
-- plugins/telescope.lua — Fuzzy finder (Telescope)
-- =============================================================================
-- Keymaps (all under <leader>f  for "find"):
--   <leader>ff  — Find files
--   <leader>fg  — Live grep (search file contents)
--   <leader>fb  — Browse open buffers
--   <leader>fh  — Search help tags
--   <leader>fr  — Recent files
--   <leader>fs  — Search LSP document symbols
--   <leader>fw  — Search for word under cursor
--   <leader>fd  — Search LSP diagnostics
--   <leader>gc  — Git commits
--   <leader>gb  — Git branches
-- =============================================================================

return {
  {
    "nvim-telescope/telescope.nvim",
    branch       = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Optional but faster: native FZF sorter
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>",                desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",                 desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",                   desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",                 desc = "Help tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                  desc = "Recent files" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>",               desc = "Diagnostics" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>",      desc = "Document symbols" },
      { "<leader>fw", "<cmd>Telescope grep_string<cr>",               desc = "Word under cursor" },
      { "<leader>gc", "<cmd>Telescope git_commits<cr>",               desc = "Git commits" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>",              desc = "Git branches" },
    },
    config = function()
      local telescope = require("telescope")
      local actions   = require("telescope.actions")

      telescope.setup({
        defaults = {
          prompt_prefix   = "  ",
          selection_caret = " ",
          path_display    = { "smart" },
          file_ignore_patterns = {
            "^.git/", "^node_modules/", "^__pycache__/",
            "%.pyc", "%.pyo",
          },
          mappings = {
            i = {
              ["<C-j>"]  = actions.move_selection_next,
              ["<C-k>"]  = actions.move_selection_previous,
              ["<C-q>"]  = actions.send_selected_to_qflist + actions.open_qflist,
              ["<Esc>"]  = actions.close,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,   -- Include hidden files (respects .gitignore)
          },
        },
      })

      -- Load fzf extension if available
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
