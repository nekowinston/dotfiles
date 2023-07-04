local lsp_present, lspconfig = pcall(require, "lspconfig")

if not lsp_present then
  return
end

local M = {}

M.setup = function(opts)
  lspconfig.astro.setup(opts)
  lspconfig.cssls.setup(opts)
  lspconfig.emmet_ls.setup(opts)
  lspconfig.graphql.setup(vim.tbl_extend("keep", {
    filetypes = {
      "graphql",
      "typescriptreact",
      "javascriptreact",
      "typescript",
    },
  }, opts))
  lspconfig.html.setup(opts)
  lspconfig.intelephense.setup(opts)
  lspconfig.tailwindcss.setup(vim.tbl_extend("keep", {
    filetypes = {
      "astro",
      "javascriptreact",
      "typescriptreact",
      "html",
      "css",
    },
  }, opts))

  -- attach tsserver only when there's a 'package.json' file in the CWD
  lspconfig.tsserver.setup(vim.tbl_extend("keep", {
    root_dir = lspconfig.util.root_pattern("package.json"),
    single_file_support = false,
  }, opts))

  -- attach deno only when there's a 'deps.ts' file in the CWD
  lspconfig.denols.setup(vim.tbl_extend("keep", {
    root_dir = lspconfig.util.root_pattern("deps.ts"),
    single_file_support = false,
  }, opts))
end

return M
