local lsp_present, lspconfig = pcall(require, "lspconfig")
local cmp_present, cmp = pcall(require, "cmp")
local navic_present, navic = pcall(require, "nvim-navic")
local luasnip_present, luasnip = pcall(require, "luasnip")

if not (cmp_present and lsp_present and luasnip_present) then
  return
end

vim.opt.completeopt = "menu,menuone,noselect"
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").load({
  path = { vim.fn.stdpath("config") .. "/snippets" },
})
vim.lsp.set_log_level("error")

-- border style
require("lspconfig.ui.windows").default_options.border = "double"
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = vim.g.bc.style,
})
local cmp_borders = {
  border = {
    vim.g.bc.topleft,
    vim.g.bc.horiz,
    vim.g.bc.topright,
    vim.g.bc.vert,
    vim.g.bc.botright,
    vim.g.bc.horiz,
    vim.g.bc.botleft,
    vim.g.bc.vert,
  },
  winhighlight = "Normal:CmpPmenu,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None",
}

-- stylua: ignore
local has_words_before = function()
  ---@diagnostic disable-next-line: deprecated
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
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
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
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
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "vim-dadbod-completion" },
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

vim.api.nvim_create_autocmd("BufRead", {
  group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
  pattern = "Cargo.toml",
  callback = function()
    cmp.setup.buffer({ sources = { { name = "crates" } } })
  end,
})

local git_ft = { "gitcommit", "NeogitCommitMessage", "Octo" }
cmp.setup.filetype(git_ft, {
  sources = cmp.config.sources({
    { name = "git" },
  }, {
    { name = "buffer" },
  }),
})
require("cmp_git").setup({
  filetypes = git_ft,
  enableRemoteUrlRewrites = true,
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

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if navic_present and client.server_capabilities.documentSymbolProvider then
      navic.attach(client, ev.buf)
    end

    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<space>lr", "<cmd>LspRestart<CR>", opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "<space>fm", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end,
})

-- register jq for jqls
vim.cmd([[au BufRead,BufNewFile *.jq setfiletype jq]])

local common = { capabilities = capabilities }

require("lsp.go").setup(common)
require("lsp.ltex").setup(common)
require("lsp.helm-ls")
require("lsp.null-ls")
require("lsp.validation").setup(common)
require("lsp.webdev").setup(common)
-- external dependencies
pcall(require("py_lsp").setup, common)
pcall(require("rust-tools").setup, {
  server = {
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          autoReload = true,
          target = "wasm32-unknown-unknown",
        },
        checkOnSave = {
          allTargets = true,
        },
      },
    },
  },
  tools = {
    executor = require("rust-tools.executors").toggleterm,
  },
})

lspconfig.nil_ls.setup(vim.tbl_extend("keep", {
  settings = {
    ["nil"] = {
      formatting = { command = { "alejandra" } },
      nix = { maxMemoryMB = nil },
    },
  },
}, common))

local servers = {
  "astro",
  "bashls",
  "dockerls",
  "helm_ls",
  "jqls",
  "lua_ls",
  "serve_d",
  "taplo",
  "teal_ls",
}

for _, server in ipairs(servers) do
  lspconfig[server].setup(common)
end
