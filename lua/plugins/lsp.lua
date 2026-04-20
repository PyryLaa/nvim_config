-- =============================================================================
-- plugins/lsp.lua — Language Server Protocol (Neovim 0.11+ native API)
-- =============================================================================
-- Neovim 0.11 introduced vim.lsp.config() and vim.lsp.enable() which replace
-- nvim-lspconfig's server setup. This file uses the native API directly.
--
-- mason.nvim still handles binary installation (:Mason to open the UI).
-- mason-tool-installer auto-installs the servers listed in format.lua.
--
-- To add a new language server:
--   1. Add its Mason package name to ensure_installed in format.lua
--   2. Call vim.lsp.config('<server>', { ... }) and vim.lsp.enable('<server>')
--      below, following the same pattern as the existing servers.
--
-- References:
--   :help lsp-config          — vim.lsp.config() docs
--   :help vim.lsp.enable()    — vim.lsp.enable() docs
--   https://github.com/williamboman/mason.nvim#available-packages
-- =============================================================================

return {
  -- ── Mason: binary installer UI ────────────────────────────────────────────
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    keys = { { "<leader>M", "<cmd>Mason<cr>", desc = "Open Mason installer" } },
    opts = { ui = { border = "rounded" } },
  },

  -- ── LSP configuration (no nvim-lspconfig needed on 0.11+) ─────────────────
  {
    -- nvim-lspconfig is kept only for its bundled server cmd/root_dir
    -- defaults (filetypes, default_config). We do NOT call lspconfig.X.setup().
    -- Remove this dep entirely once you no longer need the defaults shim.
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      { "j-hui/fidget.nvim", opts = {} }, -- LSP progress in the corner
    },
    config = function()
      -- ── Capabilities: advertise nvim-cmp to every server ──────────────────
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      pcall(function()
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
      end)

      -- ── Diagnostic display ────────────────────────────────────────────────
      vim.diagnostic.config({
        virtual_text = { prefix = "●" },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = "always" },
      })

      -- ── Shared keymaps (attached once per buffer via LspAttach) ──────────
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
        callback = function(ev)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
          end

          -- Navigation
          map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
          map("n", "gr", vim.lsp.buf.references, "Go to references")
          map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
          map("n", "gt", vim.lsp.buf.type_definition, "Go to type definition")
          map("n", "K", vim.lsp.buf.hover, "Hover documentation")
          map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")

          -- Code actions & rename
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")

          -- Diagnostics
          map("n", "<leader>dl", vim.diagnostic.open_float, "Show diagnostic")
          map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
          map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")

          -- Workspace
          map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace symbols")
        end,
      })

      -- ── Server configurations (vim.lsp.config + vim.lsp.enable) ──────────
      -- Mason installs binaries to ~/.local/share/nvim/mason/bin/
      -- Add that path so vim.lsp can find the executables.
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
      if not vim.tbl_contains(vim.split(vim.env.PATH, ":"), mason_bin) then
        vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
      end

      -- ── Python: Pyright ──────────────────────────────────────────────────
      vim.lsp.config("pyright", {
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "off", -- Pylance defaults to off
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "openFilesOnly", -- Pylance default, not "workspace"
              autoImportCompletions = true,
            },
          },
        },
      })
      vim.lsp.enable("pyright")

      -- ── C/C++: clangd ─────────────────────────────────────────────────────────
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp", "objc", "objcpp" },
        callback = function()
          vim.lsp.start({
            name = "clangd",
            cmd = {
              "/usr/lib/llvm-22/bin/clangd",
              "--background-index",
              "--clang-tidy",
              "--log=error",
            },
            root_dir = vim.fs.root(0, { "compile_commands.json", ".clangd", ".git", "Makefile" }),
            capabilities = capabilities,
          })
        end,
      })

      -- ── CMake: neocmakelsp ─────────────────────────────────────────────────────────
      vim.lsp.config("neocmake", {})
      vim.lsp.enable("neocmake")

      -- ── Lua ───────────────────────────────────────────────────────────────
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })
      vim.lsp.enable("lua_ls")

      -- ── Bash ─────────────────────────────────────────────────────────────
      vim.lsp.config("bashls", {
        capabilities = capabilities,
      })
      vim.lsp.enable("bashls")

      -- ── JSON ─────────────────────────────────────────────────────────────
      vim.lsp.config("jsonls", { capabilities = capabilities })
      vim.lsp.enable("jsonls")

      -- ── YAML ─────────────────────────────────────────────────────────────
      vim.lsp.config("yamlls", { capabilities = capabilities })
      vim.lsp.enable("yamlls")
    end,
  },
}
