# Neovim Configuration — Python + Lua

A modular, well-commented Neovim configuration targeting Python development.

---

## Requirements

| Tool | Purpose |
|------|---------|
| Neovim ≥ 0.9 | Core editor |
| Git | Plugin manager bootstrap |
| Node.js ≥ 16 | Required by some LSP servers |
| Python 3 + pip | For debugpy, ruff |
| `ruff` | Linter + formatter (`pip install ruff`) |
| `lazygit` | Optional — full-screen git TUI |
| A [Nerd Font](https://www.nerdfonts.com/) | Icons in the UI |
| `make` | For building the native fzf sorter |
| `ripgrep` | For Telescope live grep (`brew install ripgrep`) |
| `fd` | For Telescope file finding (`brew install fd`) |

---

## Installation

```bash
# Back up any existing config first
mv ~/.config/nvim ~/.config/nvim.bak

# Copy this configuration
cp -r /path/to/this/nvim ~/.config/nvim

# Launch Neovim — lazy.nvim installs itself and all plugins on first launch
nvim
```

On first launch, Mason will auto-install:
- `pyright` (Python LSP)
- `ruff` (linter + formatter)
- `lua_ls`, `bashls`, `jsonls`, `yamlls`
- `stylua`, `prettier`, `shfmt`

---

## Directory Structure

```
~/.config/nvim/
├── init.lua                 ← Entry point (loads core/* in order)
└── lua/
    ├── core/
    │   ├── options.lua      ← Editor settings (tabs, numbers, etc.)
    │   ├── keymaps.lua      ← Global key mappings (no plugin deps)
    │   ├── autocmds.lua     ← Auto commands (trim whitespace, restore cursor…)
    │   └── lazy.lua         ← Bootstraps lazy.nvim, loads lua/plugins/*
    └── plugins/
        ├── colorscheme.lua  ← Theme (Catppuccin)
        ├── ui.lua           ← Statusline, bufferline, indent guides, etc.
        ├── explorer.lua     ← File tree (nvim-tree)
        ├── telescope.lua    ← Fuzzy finder
        ├── treesitter.lua   ← Syntax highlighting + text objects
        ├── lsp.lua          ← LSP servers (pyright, lua_ls, …)
        ├── format.lua       ← Formatting (conform.nvim + ruff)
        ├── lint.lua         ← Linting (nvim-lint + ruff)
        ├── completion.lua   ← Autocompletion (nvim-cmp + LuaSnip)
        ├── git.lua          ← Git signs + LazyGit
        ├── editing.lua      ← Surround, comments, trouble, flash, …
        └── python.lua       ← DAP debugger + venv selector
```

**The rule:** each file in `lua/plugins/` is an independent lazy.nvim spec.
You can add, remove, or disable any file without touching the others.

---

## Key Bindings Quick Reference

`<leader>` is **Space**.

### Files & Navigation
| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file explorer |
| `<leader>ef` | Reveal current file in explorer |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (search file contents) |
| `<leader>fb` | Browse open buffers |
| `<leader>fr` | Recent files |
| `<leader>fw` | Search word under cursor |
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `<leader>bd` | Delete buffer |

### LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover documentation |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `<leader>dl` | Show diagnostics float |
| `]d` / `[d` | Next / prev diagnostic |

### Code Quality
| Key | Action |
|-----|--------|
| `<leader>cf` | Format buffer |
| `<leader>tf` | Toggle format-on-save |
| `<leader>cl` | Trigger linting manually |
| `<leader>xx` | Toggle Trouble (diagnostics panel) |
| `<leader>ft` | Find TODOs with Telescope |

### Git
| Key | Action |
|-----|--------|
| `<leader>gg` | Open LazyGit |
| `]h` / `[h` | Next / prev git hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hb` | Blame line |
| `<leader>hp` | Preview hunk |

### Debugging (Python)
| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue / start session |
| `<leader>di` | Step into |
| `<leader>do` | Step over |
| `<leader>du` | Toggle debug UI |
| `<leader>dm` | Debug test method |
| `<leader>vs` | Select Python venv |

### Editing
| Key | Action |
|-----|--------|
| `gcc` | Toggle line comment |
| `gc` (visual) | Toggle comment on selection |
| `ysiw"` | Surround word with `"` |
| `cs"'` | Change surrounding `"` to `'` |
| `ds"` | Delete surrounding `"` |
| `s` | Flash jump (2 chars → anywhere) |

### Manager UIs
| Key | Action |
|-----|--------|
| `<leader>L` | Open Lazy plugin manager |
| `<leader>M` | Open Mason tool installer |

---

## How to Customise

### Change the colour scheme

Edit `lua/plugins/colorscheme.lua`.

```lua
-- Change Catppuccin flavour:
opts = { flavour = "latte" }  -- "latte" | "frappe" | "macchiato" | "mocha"

-- Or replace the whole plugin with another theme, e.g. tokyonight:
return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config   = function() vim.cmd.colorscheme("tokyonight") end,
  },
}
```

### Add a new language (LSP + formatter)

1. **Find the server name** at https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers

2. **Add it to mason's `ensure_installed`** in `lua/plugins/lsp.lua`:
   ```lua
   ensure_installed = { "pyright", "lua_ls", "tsserver" },  -- add tsserver
   ```

3. **Register it with lspconfig** in the same file:
   ```lua
   lspconfig.tsserver.setup({ on_attach = on_attach, capabilities = capabilities })
   ```

4. **Add a formatter** in `lua/plugins/format.lua`:
   ```lua
   formatters_by_ft = {
     python     = { "ruff_format" },
     typescript = { "prettier" },  -- add this
   }
   ```

### Change ruff's line length

In `lua/plugins/format.lua`:
```lua
formatters = {
  ruff_format = {
    prepend_args = { "--line-length", "100" },
  },
},
```

Or (preferred) add a `pyproject.toml` in your project root:
```toml
[tool.ruff]
line-length = 100
```

### Disable format-on-save for a project

Press `<leader>tf` to toggle it for the current session, or add a `.nvim.lua`
file in your project root (requires `exrc` option):
```lua
vim.g.disable_autoformat = true
```

### Add a new plugin

Create a new file in `lua/plugins/`, e.g. `lua/plugins/markdown.lua`:
```lua
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    opts = {},
  },
}
```
Then run `:Lazy sync`.

### Disable an existing plugin

Add `enabled = false` to its spec, or delete its file.

```lua
-- In the relevant file:
return {
  {
    "kdheepak/lazygit.nvim",
    enabled = false,   -- Won't be loaded
  },
}
```

### Change tab width globally

In `lua/core/options.lua`:
```lua
opt.tabstop    = 2
opt.shiftwidth = 2
```

### Add a custom keymap

In `lua/core/keymaps.lua` (for global bindings) or inside a plugin's `config`
/ `keys` block for plugin-specific ones:
```lua
map("n", "<leader>X", "<cmd>SomeCommand<cr>", "Description shown in which-key")
```

### Configure Pyright strictness

In `lua/plugins/lsp.lua` under `lspconfig.pyright.setup`:
```lua
typeCheckingMode = "strict",  -- "off" | "basic" | "strict"
```

### Manage ruff rules

Add a `ruff.toml` or `pyproject.toml` to your project:
```toml
[tool.ruff.lint]
select = ["E", "F", "W", "I", "N", "UP", "B"]
ignore = ["E501"]   # ignore line-too-long (handled by formatter)
```

---

## Useful Commands

| Command | Description |
|---------|-------------|
| `:Lazy` | Plugin manager UI |
| `:Lazy update` | Update all plugins |
| `:Mason` | Tool installer UI |
| `:MasonUpdate` | Update installed tools |
| `:LspInfo` | Active LSP clients for current buffer |
| `:LspLog` | LSP debug log |
| `:TSInstall <lang>` | Install a Treesitter parser |
| `:ConformInfo` | Active formatters for current buffer |
| `:lua vim.diagnostic.setqflist()` | Send diagnostics to quickfix |

---

## Troubleshooting

**No icons / broken characters** → Install a [Nerd Font](https://www.nerdfonts.com/)
and set it as your terminal font.

**LSP not starting** → Run `:LspInfo` to see what's attached, `:Mason` to verify
the server is installed.

**Ruff not formatting** → Run `:ConformInfo` to see active formatters. Check
`ruff` is on your PATH: `:!which ruff`.

**Slow startup** → Run `:Lazy profile` to see which plugins are taking the most
time. Consider setting `lazy = true` on heavy plugins.
