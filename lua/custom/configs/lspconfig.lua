local base = require("plugins.configs.lspconfig")
local on_attach = base.on_attach
local capabilities = base.capabilities

local lspconfig = require("lspconfig")

lspconfig.clangd.setup {
  cmd = {
    "clangd",
    "--clang-tidy",
    "--header-insertion=never",
    "--query-driver=/usr/bin/c++",
    "--all-scopes-completion",
    "--completion-style=detailed",
  },
  filetypes = {"c", "cpp"},
  single_file_support = true,
  on_attach = function(client, bufnr)
    client.server_capabilities.signatureHelpProvider = false
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
}
