-- =============================================================================
-- core/autocmds.lua — Automatic commands
-- =============================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ── Highlight yanked text briefly ────────────────────────────────────────────
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- ── Remove trailing whitespace on save ───────────────────────────────────────
augroup("TrimWhitespace", { clear = true })
autocmd("BufWritePre", {
  group = "TrimWhitespace",
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- ── Restore cursor position when reopening a file ────────────────────────────
augroup("RestoreCursor", { clear = true })
autocmd("BufReadPost", {
  group = "RestoreCursor",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ── Auto-resize splits when the terminal window is resized ───────────────────
augroup("AutoResize", { clear = true })
autocmd("VimResized", {
  group = "AutoResize",
  command = "tabdo wincmd =",
})

-- ── Python-specific settings ──────────────────────────────────────────────────
augroup("PythonSettings", { clear = true })
autocmd("FileType", {
  group = "PythonSettings",
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
    vim.opt_local.colorcolumn = "88" -- ruff's default line length
  end,
})

-- ── Close certain windows with just 'q' ──────────────────────────────────────
augroup("QuickClose", { clear = true })
autocmd("FileType", {
  group = "QuickClose",
  pattern = { "help", "qf", "man", "lspinfo", "notify" },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true, silent = true })
  end,
})

-- Activate venv automatically if found
augroup("AutoVenv", { clear = true })
autocmd("VimEnter", {
  group = "AutoVenv",
  callback = function()
    local venv = vim.fn.getcwd() .. "/.venv"
    if vim.fn.isdirectory(venv) == 1 then
      vim.env.VIRTUAL_ENV = venv
      vim.env.PATH = venv .. "/bin:" .. vim.env.PATH
      vim.notify("Activated .venv", vim.log.levels.INFO)
    end
  end,
})
