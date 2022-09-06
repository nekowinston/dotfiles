require("mason").setup({
	ui = {
		border = "none",
		icons = {
			package_installed = " ",
			package_pending = " ",
			package_uninstalled = " ",
		},
	},
})
require("mason-lspconfig").setup({ automatic_installation = true })

vim.opt.completeopt = "menu,menuone,noselect"

-- debug mode enabled
-- vim.lsp.set_log_level("debug")

-- Setup nvim-cmp.
local present, cmp = pcall(require, "cmp")
if not present then
	return
end

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<Tab>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "vsnip" },
	}, { { name = "buffer" } }),
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" },
	}, { { name = "buffer" } }),
})
-- search
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = { { name = "buffer" } },
})
-- Use cmdline & path source for ':'
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources(
		{ {
			name = "path",
			option = { trailing_slash = true },
		} },
		{ { name = "cmdline" } }
	),
})

-- Setup lspconfig.
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
---@diagnostic disable-next-line: unused-local
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- disable diagnostics on Helm files
	if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
		vim.diagnostic.disable()
	end

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<space>nf", function()
		vim.lsp.buf.format({
			-- filter to only use null-ls
			filter = function(c)
				return c.name == "null-ls"
			end,
			bufnr = bufnr,
		})
	end, bufopts)
end

local common_config = {
	on_attach = on_attach,
	capabilities = capabilities,
}

local present, lsp = pcall(require, "lspconfig")
if not present then
	return
end

lsp.sumneko_lua.setup({
	on_attach = on_attach,
	capabilities = capabilities,
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
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

--- the cool kids
lsp.bashls.setup(common_config)
lsp.gopls.setup(common_config)
lsp.pyright.setup(common_config)
lsp.rust_analyzer.setup(common_config)

--- Web Development
lsp.cssls.setup(common_config)
local emmet_cap = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
emmet_cap.textDocument.completion.completionItem.snippetSupport = true
lsp.emmet_ls.setup({
	on_attach = on_attach,
	capabilities = emmet_cap,
	filetypes = {
		"javascriptreact",
		"typescriptreact",
		"html",
		"svelte",
		"css",
		"less",
		"sass",
		"scss",
	},
})
-- lsp.html.setup(common_config)
lsp.tailwindcss.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		emmetCompletions = true,
	},
})

-- soydev
lsp.prismals.setup(common_config)
lsp.svelte.setup(common_config)
-- attach tsserver only when there's a 'package.json' file in the CWD
lsp.tsserver.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	root_dir = lsp.util.root_pattern("package.json"),
})
-- attach deno only when there's a 'deps.ts' file in the CWD
lsp.denols.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	root_dir = lsp.util.root_pattern("deps.ts"),
	single_file_support = false,
})

-- data formats
lsp.dockerls.setup(common_config)
lsp.graphql.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	root_dir = lsp.util.root_pattern(".graphqlrc*", ".graphql.config.*", "graphql.config.*"),
	settings = {
		graphql = {
			schemaPath = "schema.graphql",
		},
	},
})
lsp.jsonls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
})
lsp.yamlls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		redhat = {
			telemetry = {
				enabled = false,
			},
		},
		yaml = {
			schemas = {
				["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.24.2-standalone-strict/all.json"] = {
					"*.k8s.yaml",
					"*.k8s.yml",
					"kubectl-edit-*.yaml",
				},
			},
		},
	},
})

--- Documentation
lsp.ltex.setup(common_config)
