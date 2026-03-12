-- =============================================================================
-- plugins/completion.lua — Autocompletion (nvim-cmp)
-- =============================================================================
-- Sources (in priority order):
--   1. LSP                 — type info, signatures, completions from Pyright
--   2. LuaSnip snippets    — expandable snippet templates
--   3. Buffer words        — words already in open buffers
--   4. File paths          — complete file system paths
--
-- Key bindings inside the completion menu:
--   <C-j> / <C-k>   — Navigate items
--   <C-b> / <C-f>   — Scroll documentation
--   <CR>            — Confirm selection
--   <Tab>           — Select next / expand snippet / jump next placeholder
--   <S-Tab>         — Select prev / jump prev placeholder
--   <C-e>           — Close menu
--   <C-Space>       — Force open menu
-- =============================================================================

return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",       -- LSP completions
      "hrsh7th/cmp-buffer",         -- Buffer word completions
      "hrsh7th/cmp-path",           -- File path completions
      "saadparwaiz1/cmp_luasnip",   -- Snippet completions
      {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          -- Load VS Code-style snippets (including Python snippets)
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
      "onsails/lspkind.nvim",       -- VS Code-style icons in completion menu
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },

        window = {
          completion    = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-j>"]     = cmp.mapping.select_next_item(),
          ["<C-k>"]     = cmp.mapping.select_prev_item(),
          ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
          ["<C-f>"]     = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),
          ["<CR>"]      = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip",  priority = 750  },
          { name = "buffer",   priority = 500  },
          { name = "path",     priority = 250  },
        }),

        formatting = {
          format = lspkind.cmp_format({
            mode        = "symbol_text",
            maxwidth    = 50,
            ellipsis    = "…",
            before      = function(entry, vim_item)
              -- Show the source name in brackets
              vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip  = "[Snippet]",
                buffer   = "[Buffer]",
                path     = "[Path]",
              })[entry.source.name]
              return vim_item
            end,
          }),
        },

        -- Don't complete in comments
        enabled = function()
          local ctx = require("cmp.config.context")
          if vim.api.nvim_get_mode().mode == "c" then return true end
          return not ctx.in_treesitter_capture("comment")
            and not ctx.in_syntax_group("Comment")
        end,
      })
    end,
  },
}
