local lsp_present, lspconfig = pcall(require, "lspconfig")

if not lsp_present then
  return
end

local M = {}

M.setup = function(opts)
  lspconfig.ltex.setup({
    capabilities = opts.capabilities,
    on_attach = function()
      require("ltex_extra").setup({
        load_langs = { "en-US", "de-AT" },
        init_check = true,
        path = vim.fn.stdpath("data") .. "/dictionary",
      })
    end,
    settings = {
      ltex = {},
    },
  })
end

return M
