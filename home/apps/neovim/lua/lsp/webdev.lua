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
  require("typescript-tools").setup({
    single_file_support = false,
    root_dir = function(fname)
      local root_dir = lspconfig.util.root_pattern("tsconfig.json")(fname)

      -- this is needed to make sure we don't pick up root_dir inside node_modules
      local node_modules_index = root_dir
        and root_dir:find("node_modules", 1, true)
      if node_modules_index and node_modules_index > 0 then
        ---@diagnostic disable-next-line: need-check-nil
        root_dir = root_dir:sub(1, node_modules_index - 2)
      end

      return root_dir
    end,
    settings = {
      expose_as_code_action = {
        "add_missing_imports",
        "fix_all",
        "remove_unused",
      },
      -- Nix silliness
      -- stylua: ignore
      tsserver_path = vim.fn.resolve(vim.fn.exepath("tsserver") .. "/../../lib/node_modules/typescript/bin/tsserver"),
    },
  })

  -- attach deno only when there's a 'deps.ts' file in the CWD
  lspconfig.denols.setup(vim.tbl_extend("keep", {
    root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
    single_file_support = false,
  }, opts))
end

return M
