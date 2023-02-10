-- vim:fdm=marker
vim.opt.completeopt = "menu,menuone,noselect"
vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets"
vim.lsp.set_log_level("error")

-- cmp {{{
local present, cmp = pcall(require, "cmp")
if not present or not cmp then
  return
end

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

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "double",
})

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  window = {
    completion = {
      border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
      winhighlight = "Normal:CmpPmenu,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None",
    },
    documentation = {
      border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
      winhighlight = "Normal:CmpPmenu,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None",
    },
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
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
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
-- }}}

local capabilities = require("cmp_nvim_lsp").default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

---@diagnostic disable-next-line: unused-local
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
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
end
local lspconfig = require("lspconfig")
require("lspconfig.ui.windows").default_options.border = "double"

-- lua {{{
lspconfig.sumneko_lua.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
      diagnostics = {
        globals = { "vim" }, -- Get the server to recognize the `vim` global
      },
      telemetry = {
        enable = false,
      },
    },
  },
})
-- }}}

-- webdev {{{
lspconfig.astro.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

lspconfig.tailwindcss.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = {
    "javascriptreact",
    "typescriptreact",
    "html",
    "css",
  },
})
-- attach tsserver only when there's a 'package.json' file in the CWD
lspconfig.tsserver.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern("package.json"),
  single_file_support = false,
})
-- attach deno only when there's a 'deps.ts' file in the CWD
lspconfig.denols.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern("deps.ts"),
  single_file_support = false,
})
-- }}}

-- DOCKERFILE
lspconfig.dockerls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})
lspconfig.bashls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})
lspconfig.rnix.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

vim.cmd([[au BufRead,BufNewFile *.jq setfiletype jq]])
lspconfig.jqls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- data {{{
lspconfig.jsonls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})
lspconfig.taplo.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})
lspconfig.yamlls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    yaml = {
      completion = true,
      validate = true,
      suggest = {
        parentSkeletonSelectedFirst = true,
      },
      schemas = {
        ["https://json.schemastore.org/github-action"] = ".github/action.{yaml,yml}",
        ["https://json.schemastore.org/github-workflow"] = ".github/workflows/*",
        ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "*lab-ci.{yaml,yml}",
        ["https://json.schemastore.org/helmfile"] = "helmfile.{yaml,yml}",
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose.yml.{yml,yaml}",
        -- stylua: ignore
        kubernetes = {
          '*-deployment.yaml', '*-deployment.yml', '*-service.yaml', '*-service.yml', 'clusterrole-contour.yaml',
          'clusterrole-contour.yml', 'clusterrole.yaml', 'clusterrole.yml', 'clusterrolebinding.yaml',
          'clusterrolebinding.yml', 'configmap.yaml', 'configmap.yml', 'cronjob.yaml', 'cronjob.yml', 'daemonset.yaml',
          'daemonset.yml', 'deployment-*.yaml', 'deployment-*.yml', 'deployment.yaml', 'deployment.yml', 'hpa.yaml',
          'hpa.yml', 'ingress.yaml', 'ingress.yml', 'job.yaml', 'job.yml', 'kubectl-edit-*.yaml', 'namespace.yaml',
          'namespace.yml', 'pvc.yaml', 'pvc.yml', 'rbac.yaml', 'rbac.yml', 'replicaset.yaml', 'replicaset.yml',
          'role.yaml', 'role.yml', 'rolebinding.yaml', 'rolebinding.yml', 'sa.yaml', 'sa.yml', 'secret.yaml',
          'secret.yml', 'service-*.yaml', 'service-*.yml', 'service-account.yaml', 'service-account.yml', 'service.yaml',
          'service.yml', 'serviceaccount.yaml', 'serviceaccount.yml', 'serviceaccounts.yaml', 'serviceaccounts.yml',
          'statefulset.yaml', 'statefulset.yml'
        },
      },
    },
  },
})
-- }}}

-- Latex {{{
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
-- }}}

lspconfig.teal_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Null LS
local null = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null.setup({
  sources = {
    null.builtins.formatting.alejandra,
    null.builtins.formatting.black,
    null.builtins.formatting.deno_fmt,
    null.builtins.formatting.gofumpt,
    null.builtins.formatting.isort,
    null.builtins.formatting.prettier,
    null.builtins.formatting.rustfmt,
    null.builtins.formatting.shfmt,
    null.builtins.formatting.stylua,
    null.builtins.diagnostics.proselint,
    null.builtins.diagnostics.statix,
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
})

local toggle_formatters = function()
  null.toggle({ methods = null.methods.FORMATTING })
end

vim.api.nvim_create_user_command("ToggleFormatters", toggle_formatters, {})

-- go (with nvim-go) {{{
require("go").setup({
  disable_defaults = false, -- true|false when true set false to all boolean settings and replace all table
  -- settings with {}
  go = "go", -- go command, can be go[default] or go1.18beta1
  goimport = "gopls", -- goimport command, can be gopls[default] or goimport
  fillstruct = "gopls", -- can be nil (use fillstruct, slower) and gopls
  gofmt = "gofumpt", --gofmt cmd,
  max_line_len = 128, -- max line length in golines format, Target maximum line length for golines
  tag_transform = false, -- can be transform option("snakecase", "camelcase", etc) check gomodifytags for details and more options
  gotests_template = "", -- sets gotests -template parameter (check gotests for details)
  gotests_template_dir = "", -- sets gotests -template_dir parameter (check gotests for details)
  comment_placeholder = "", -- comment_placeholder your cool placeholder e.g. ﳑ       
  icons = { breakpoint = "🧘", currentpos = "🏃" },
  verbose = false, -- output loginf in messages
  lsp_cfg = {
    on_attach = on_attach,
    capabilities = capabilities,
  },
  lsp_gofumpt = true, -- true: set default gofmt in gopls format to gofumpt
  lsp_on_attach = nil, -- nil: use on_attach function defined in go/lsp.lua,
  --      when lsp_cfg is true
  -- if lsp_on_attach is a function: use this function as on_attach function for gopls
  lsp_keymaps = true, -- set to false to disable gopls/lsp keymap
  lsp_codelens = true, -- set to false to disable codelens, true by default, you can use a function
  -- function(bufnr)
  --    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>F", "<cmd>lua vim.lsp.buf.formatting()<CR>", {noremap=true, silent=true})
  -- end
  -- to setup a table of codelens
  lsp_diag_hdlr = true, -- hook lsp diag handler
  lsp_diag_underline = true,
  -- virtual text setup
  lsp_diag_virtual_text = { space = 0, prefix = "" },
  lsp_diag_signs = true,
  lsp_diag_update_in_insert = false,
  lsp_document_formatting = true,
  -- set to true: use gopls to format
  -- false if you want to use other formatter tool(e.g. efm, nulls)
  lsp_inlay_hints = {
    enable = true,
    -- Only show inlay hints for the current line
    only_current_line = false,
    -- Event which triggers a refersh of the inlay hints.
    -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
    -- not that this may cause higher CPU usage.
    -- This option is only respected when only_current_line and
    -- autoSetHints both are true.
    only_current_line_autocmd = "CursorHold",
    -- whether to show variable name before type hints with the inlay hints or not
    -- default: false
    show_variable_name = true,
    -- prefix for parameter hints
    parameter_hints_prefix = " ",
    show_parameter_hints = true,
    -- prefix for all the other hints (type, chaining)
    other_hints_prefix = "=> ",
    -- whether to align to the lenght of the longest line in the file
    max_len_align = false,
    -- padding from the left if max_len_align is true
    max_len_align_padding = 1,
    -- whether to align to the extreme right or not
    right_align = false,
    -- padding from the right if right_align is true
    right_align_padding = 6,
    -- The color of the hints
    highlight = "InlayHint",
  },
  gopls_cmd = nil, -- if you need to specify gopls path and cmd, e.g {"/home/user/lsp/gopls", "-logfile","/var/log/gopls.log" }
  gopls_remote_auto = true, -- add -remote=auto to gopls
  gocoverage_sign = "█",
  sign_priority = 5, -- change to a higher number to override other signs
  dap_debug = true, -- set to false to disable dap
  dap_debug_keymap = true, -- true: use keymap for debugger defined in go/dap.lua
  -- false: do not use keymap in go/dap.lua.  you must define your own.
  -- windows: use visual studio keymap
  dap_debug_gui = true, -- set to true to enable dap gui, highly recommend
  dap_debug_vt = true, -- set to true to enable dap virtual text
  build_tags = "", -- set default build tags
  textobjects = true, -- enable default text jobects through treesittter-text-objects
  test_runner = "go", -- one of {`go`, `richgo`, `dlv`, `ginkgo`, `gotestsum`}
  verbose_tests = true, -- set to add verbose flag to tests
  run_in_floaterm = false, -- set to true to run in float window. :GoTermClose closes the floatterm
  -- float term recommend if you use richgo/ginkgo with terminal color

  trouble = false, -- true: use trouble to open quickfix
  test_efm = false, -- errorfomat for quickfix, default mix mode, set to true will be efm only
  luasnip = false, -- enable included luasnip snippets. you can also disable while add lua/snips folder to luasnip load
  --  Do not enable this if you already added the path, that will duplicate the entries
})
-- }}}

require("rust-tools").setup({
  server = {
    on_attach = on_attach,
    capabilities = capabilities,
  },
})

require("py_lsp").setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

local configs = require("lspconfig.configs")
local util = require("lspconfig.util")

if not configs.helm_ls then
  configs.helm_ls = {
    default_config = {
      cmd = { "helm-ls", "serve" },
      filetypes = { "helm" },
      root_dir = function(fname)
        return util.root_pattern("Chart.yaml")(fname)
      end,
    },
  }
end

lspconfig.helm_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})
