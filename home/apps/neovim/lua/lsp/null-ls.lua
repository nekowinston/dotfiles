-- Null LS
local null = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null.setup({
  sources = {
    null.builtins.formatting.alejandra,
    null.builtins.formatting.black,
    null.builtins.formatting.deno_fmt.with({
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
      },
    }),
    null.builtins.formatting.gofumpt,
    null.builtins.formatting.isort,
    null.builtins.formatting.prettier,
    null.builtins.formatting.rustfmt,
    null.builtins.formatting.shfmt,
    null.builtins.formatting.stylua,
    null.builtins.formatting.taplo,
    null.builtins.diagnostics.alex,
    null.builtins.diagnostics.proselint,
    null.builtins.diagnostics.deadnix.with({
      -- ignore dead lambda arguments
      extra_args = { "-l", "-L" },
    }),
    null.builtins.hover.dictionary,
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            bufnr = bufnr,
            filter = function(c)
              return c.name == "null-ls"
            end,
          })
        end,
      })
    end
  end,
})

local toggle_formatters = function()
  null.toggle({ methods = null.methods.FORMATTING })
end

vim.api.nvim_create_user_command("ToggleFormatters", toggle_formatters, {})