-- =============================================================================
-- core/options.lua — Vim/Neovim editor options
-- =============================================================================
-- Customize anything here to your liking.
-- Full option reference: :help option-list
-- =============================================================================

local opt = vim.opt

-- ── UI ────────────────────────────────────────────────────────────────────────
opt.number = true -- Show absolute line numbers
opt.relativenumber = true -- Show relative line numbers (great for jumps)
opt.cursorline = true -- Highlight the current line
opt.signcolumn = "yes" -- Always show sign column (prevents layout shift)
opt.colorcolumn = "100" -- Vertical ruler at 88 chars (ruff's default)
opt.scrolloff = 8 -- Keep 8 lines visible above/below cursor
opt.sidescrolloff = 8
opt.wrap = false -- Don't wrap long lines
opt.termguicolors = true -- Enable 24-bit colour
opt.showmode = false -- Mode shown by statusline instead
opt.cmdheight = 1 -- Command bar height
opt.pumheight = 10 -- Max items in completion popup

-- ── Indentation ───────────────────────────────────────────────────────────────
opt.expandtab = true -- Use spaces instead of tabs
opt.tabstop = 4 -- Visual width of a tab character
opt.shiftwidth = 4 -- Width of auto-indent (matches PEP 8)
opt.softtabstop = 4
opt.smartindent = true -- Smart auto-indenting on new lines

-- ── Search ────────────────────────────────────────────────────────────────────
opt.ignorecase = true -- Case-insensitive search by default …
opt.smartcase = true -- … unless the pattern contains uppercase
opt.hlsearch = true -- Highlight search matches
opt.incsearch = true -- Show matches while typing

-- ── Files & Buffers ───────────────────────────────────────────────────────────
opt.hidden = true -- Allow switching away from modified buffers
opt.swapfile = false -- No swap files
opt.backup = false -- No backup files
opt.undofile = true -- Persistent undo (stored in undodir)
opt.undodir = vim.fn.stdpath("data") .. "/undodir" -- e.g. ~/.local/share/nvim/undodir

-- ── Splits ────────────────────────────────────────────────────────────────────
opt.splitright = true -- Vertical splits open to the right
opt.splitbelow = true -- Horizontal splits open below

-- ── Clipboard ─────────────────────────────────────────────────────────────────
-- Remove this line if you do NOT want system clipboard integration.
opt.clipboard = "unnamedplus"

-- ── Performance ───────────────────────────────────────────────────────────────
opt.updatetime = 250 -- Faster CursorHold events (used by LSP hover, etc.)
opt.timeoutlen = 400 -- Shorter wait for mapped key sequences

-- ── Completion ────────────────────────────────────────────────────────────────
opt.completeopt = { "menuone", "noselect" } -- Completion behaviour for nvim-cmp

-- ── Folding (using Treesitter) ────────────────────────────────────────────────
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false -- Open all folds by default
