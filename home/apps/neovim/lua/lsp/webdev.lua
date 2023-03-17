local lspconfig = require("lspconfig")

local M = {}

M.setup = function(opts)
  local common = {
    capabilities = opts.capabilities,
    on_attach = opts.on_attach,
  }
  lspconfig.cssls.setup(common)
  lspconfig.emmet_ls.setup(common)
  lspconfig.graphql.setup({
    capabilities = opts.capabilities,
    on_attach = opts.on_attach,
    filetypes = {
      "graphql",
      "typescriptreact",
      "javascriptreact",
      "typescript",
    },
  })
  lspconfig.intelephense.setup(common)
  lspconfig.tailwindcss.setup({
    capabilities = opts.capabilities,
    on_attach = opts.on_attach,
    filetypes = {
      "javascriptreact",
      "typescriptreact",
      "html",
      "css",
    },
  })
  -- attach tsserver only when there's a 'package.json' file in the CWD
  lspconfig.tsserver.setup({
    capabilities = opts.capabilities,
    on_attach = opts.on_attach,
    root_dir = lspconfig.util.root_pattern("package.json"),
    single_file_support = false,
  })
  -- attach deno only when there's a 'deps.ts' file in the CWD
  lspconfig.denols.setup({
    capabilities = opts.capabilities,
    on_attach = opts.on_attach,
    root_dir = lspconfig.util.root_pattern("deps.ts"),
    single_file_support = false,
  })
end

return M
