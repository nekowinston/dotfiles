local lsp_present, lspconfig = pcall(require, "lspconfig")
local cmp_present, cmp = pcall(require, "cmp")
local navic_present, navic = pcall(require, "nvim-navic")

if not (cmp_present and lsp_present) then
  return
end

vim.opt.completeopt = "menu,menuone,noselect"
vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets"
vim.lsp.set_log_level("error")

-- border style
require("lspconfig.ui.windows").default_options.border = "double"
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "double",
})
local cmp_borders = {
  border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
  winhighlight = "Normal:CmpPmenu,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None",
}

local has_words_before = function()
  ---@diagnostic disable-next-line: deprecated
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api
        .nvim_buf_get_lines(0, line - 1, line, true)[1]
        :sub(col, col)
        :match("%s")
      == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(key, true, true, true),
    mode,
    true
  )
end

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  window = {
    completion = cmp_borders,
    documentation = cmp_borders,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "vsnip" },
    { name = "vim-dadbod-completion" },
  }, {
    { name = "buffer" },
  }),
  formatting = {
    format = require("lspkind").cmp_format({
      mode = "symbol_text",
      maxwidth = 50,
      ellipsis_char = "...",
    }),
  },
})

cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "cmp_git" },
  }, {
    { name = "buffer" },
  }),
})

cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path", option = { trailing_slash = true } },
  }, {
    { name = "cmdline" },
  }),
})

local capabilities = require("cmp_nvim_lsp").default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

---@diagnostic disable-next-line: unused-local
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set(
    "n",
    "<leader>wr",
    vim.lsp.buf.remove_workspace_folder,
    bufopts
  )
  vim.keymap.set("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<CR>", bufopts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts)
  if navic_present and client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end

lspconfig.lua_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
        maxPreload = 150000,
        preloadFileSize = 1000,
      },
      diagnostics = {
        -- Get the server to recognize the `vim` global
        globals = { "vim" },
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

lspconfig.ltex.setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    require("ltex_extra").setup({
      load_langs = { "en-US", "de-AT" },
      init_check = true,
      path = vim.fn.stdpath("data") .. "/dictionary",
    })
    on_attach(client, bufnr)
  end,
  settings = {
    ltex = {},
  },
})

-- register jq for jqls
vim.cmd([[au BufRead,BufNewFile *.jq setfiletype jq]])

local common = {
  capabilities = capabilities,
  on_attach = on_attach,
}

require("lsp.go").setup(common)
require("lsp.helm-ls")
require("lsp.null-ls")
require("lsp.validation").setup(common)
require("lsp.webdev").setup(common)
require("py_lsp").setup(common)
require("rust-tools").setup({ server = common })

local servers = {
  "astro",
  "bashls",
  "dockerls",
  "helm_ls",
  "jqls",
  "nil",
  "taplo",
  "teal_ls",
}

for _, server in ipairs(servers) do
  lspconfig[server].setup(common)
end
