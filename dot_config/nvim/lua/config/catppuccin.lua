-- use transparency in terminal only
vim.g.catppuccin_flavour = "mocha"

require("catppuccin").setup({
	transparent_background = false,
	term_colors = true,
	dim_inactive = {
		enable = false,
		shade = "dark",
		percentage = 0.05,
	},
	styles = {
		comments = { "italic" },
		conditionals = { "italic" },
	},
	integrations = {
		treesitter = true,
		native_lsp = {
			enabled = true,
			virtual_text = {
				errors = { "italic" },
				hints = { "italic" },
				warnings = { "italic" },
				information = { "italic" },
			},
			underlines = {
				errors = { "underline" },
				hints = { "underline" },
				warnings = { "underline" },
				information = { "underline" },
			},
		},
		cmp = true,
		coc_nvim = false,
		lsp_saga = true,
		lsp_trouble = true,
		nvimtree = {
			enabled = false,
		},
		neotree = {
			enabled = true,
			show_root = false,
			transparent_panel = false,
		},
		which_key = true,
		indent_blankline = {
			enabled = true,
			colored_indent_levels = true,
		},
		barbar = false,
		bufferline = true,
		dashboard = true,
		fern = false,
		gitgutter = false,
		gitsigns = true,
		hop = false,
		leap = false,
		lightspeed = false,
		markdown = true,
		neogit = true,
		notify = true,
		symbols_outline = true,
		telekasten = false,
		telescope = true,
		ts_rainbow = true,
		vim_sneak = false,
	}
})

vim.cmd("colorscheme catppuccin")
