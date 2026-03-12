-- =============================================================================
-- core/keymaps.lua — Global key mappings (no plugin dependencies)
-- =============================================================================
-- Convention used throughout this config:
--   <leader> is set to Space (see below)
--   Plugin-specific mappings live inside each plugin's config block.
-- =============================================================================

vim.g.mapleader = " " -- Space as leader key
vim.g.maplocalleader = " "

local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

-- ── General ───────────────────────────────────────────────────────────────────
map("n", "<leader>w", "<cmd>w<cr>", "Save file")
map("n", "<leader>q", "<cmd>q<cr>", "Quit")
map("n", "<leader>Q", "<cmd>qa!<cr>", "Force quit all")
map("n", "<Esc>", "<cmd>nohlsearch<cr>", "Clear search highlight")

-- ── Better window navigation (Ctrl + hjkl) ───────────────────────────────────
map("n", "<C-h>", "<C-w>h", "Move to left window")
map("n", "<C-j>", "<C-w>j", "Move to window below")
map("n", "<C-k>", "<C-w>k", "Move to window above")
map("n", "<C-l>", "<C-w>l", "Move to right window")

-- ── Resize windows ───────────────────────────────────────────────────────────
map("n", "<C-Up>", "<cmd>resize +2<cr>", "Increase window height")
map("n", "<C-Down>", "<cmd>resize -2<cr>", "Decrease window height")
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", "Decrease window width")
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", "Increase window width")

-- ── Buffer navigation ─────────────────────────────────────────────────────────
map("n", "<S-h>", "<cmd>bprevious<cr>", "Previous buffer")
map("n", "<S-l>", "<cmd>bnext<cr>", "Next buffer")
map("n", "<leader>bd", "<cmd>bdelete<cr>", "Delete buffer")

-- ── Move selected lines up/down in visual mode ───────────────────────────────
map("v", "J", ":m '>+1<cr>gv=gv", "Move selection down")
map("v", "K", ":m '<-2<cr>gv=gv", "Move selection up")

-- ── Keep cursor centred when jumping / searching ─────────────────────────────
map("n", "<C-d>", "<C-d>zz", "Scroll down (centred)")
map("n", "<C-u>", "<C-u>zz", "Scroll up (centred)")
map("n", "n", "nzzzv", "Next search result (centred)")
map("n", "N", "Nzzzv", "Prev search result (centred)")

-- ── Paste without clobbering register ────────────────────────────────────────
map("v", "<leader>p", '"_dP', "Paste without overwriting register")

-- ── Yank to system clipboard ─────────────────────────────────────────────────
map({ "n", "v" }, "<leader>y", '"+y', "Yank to clipboard")
map("n", "<leader>Y", '"+Y', "Yank line to clipboard")

-- ── Quickfix list ─────────────────────────────────────────────────────────────
map("n", "<leader>cn", "<cmd>cnext<cr>", "Next quickfix item")
map("n", "<leader>cp", "<cmd>cprev<cr>", "Prev quickfix item")
map("n", "<leader>co", "<cmd>copen<cr>", "Open quickfix list")
map("n", "<leader>cc", "<cmd>cclose<cr>", "Close quickfix list")

-- ── Splits ────────────────────────────────────────────────────────────────────
map("n", "<leader>sv", "<cmd>vsplit<cr>", "Vertical split")
map("n", "<leader>sh", "<cmd>split<cr>", "Horizontal split")

-- ── Terminal ──────────────────────────────────────────────────────────────────
map("n", "<leader>tt", "<cmd>vsplit | terminal<cr>", "Open terminal")
map("t", "<Esc><Esc>", "<C-\\><C-n>", "Exit terminal mode")
