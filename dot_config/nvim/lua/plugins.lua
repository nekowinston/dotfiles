require("utils")

vim.cmd([[packadd packer.nvim]])
local packer = require("packer")
-- slow internet...
packer.init({
	git = { clone_timeout = 180 },
	profile = {
		enable = true,
	},
})

return packer.startup(function(use)
	-- Packer managing itself
	use("wbthomason/packer.nvim")
	-- startup time or some shit
	use("lewis6991/impatient.nvim")

	-- colour scheme
	use({
		"catppuccin/nvim",
		as = "catppuccin",
		branch = "dev",
		config = function()
			require("config/catppuccin")
		end,
	})
	use({
		"Pocco81/true-zen.nvim",
		branch = "main",
		config = function()
			require("true-zen").setup({
				modes = {
					ataraxis = {
						shade = "dark",
						backdrop = 0.00,
						quit_untoggles = true,
						padding = {
							left = 52,
							right = 52,
							top = 0,
							bottom = 0,
						},
					},
					narrow = {
						run_ataraxis = true,
					},
				},
				integrations = {
					tmux = true,
				},
			})
		end,
	})

	-- git gutter
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("config/gitsigns")
		end,
	})

	-- rainbow indents
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("indent_blankline").setup({
				space_char_blankline = " ",
				show_current_conext = true,
				char_highlight_list = {
					"IndentBlanklineIndent1",
					"IndentBlanklineIndent2",
					"IndentBlanklineIndent3",
					"IndentBlanklineIndent4",
					"IndentBlanklineIndent5",
					"IndentBlanklineIndent6",
				},
			})
			vim.g.indent_blankline_filetype_exclude = {
				"dashboard",
				"help",
				"neogitstatus",
				"fugitive",
				"packer",
				"NvimTree",
				"Trouble",
			}
		end,
	})

	-- top bar
	use({
		"akinsho/bufferline.nvim",
		config = function()
			require("bufferline").setup({
				options = {
					show_close_icon = false,
					separator_style = "slant",
					close_icon = "",
					offsets = { { filetype = "NvimTree" } },
					left_mouse_command = "buffer %d",
					middle_mouse_command = "bdelete! %d",
					right_mouse_command = nil,
				},
			})
			-- hop between buffers in order of the bar
			Nmap("<A-,>", "<Cmd>BufferLineCyclePrev<CR>")
			Nmap("<A-.>", "<Cmd>BufferLineCycleNext<CR>")
			-- Re-order to previous/next
			Nmap("<A-<>", "<Cmd>BufferLineMovePrev<CR>")
			Nmap("<A->>", "<Cmd>BufferLineMoveNext<CR>")
			-- Goto buffer in position...
			Nmap("<A-1>", "<Cmd>BufferLineGoToBuffer 1<CR>")
			Nmap("<A-2>", "<Cmd>BufferLineGoToBuffer 2<CR>")
			Nmap("<A-3>", "<Cmd>BufferLineGoToBuffer 3<CR>")
			Nmap("<A-4>", "<Cmd>BufferLineGoToBuffer 4<CR>")
			Nmap("<A-5>", "<Cmd>BufferLineGoToBuffer 5<CR>")
			Nmap("<A-6>", "<Cmd>BufferLineGoToBuffer 6<CR>")
			Nmap("<A-7>", "<Cmd>BufferLineGoToBuffer 7<CR>")
			Nmap("<A-8>", "<Cmd>BufferLineGoToBuffer 8<CR>")
			Nmap("<A-9>", "<Cmd>BufferLineGoToBuffer 9<CR>")
			Nmap("<A-0>", "<Cmd>BufferLineGoToBuffer -1<CR>")
			-- Pin/unpin buffer
			Nmap("<A-p>", "<Cmd>BufferLineTogglePin<CR>")
			-- Close buffer
			Nmap("<A-x>", "<Cmd>bdelete<CR>")
			Nmap("<A-X>", "<Cmd>bdelete!<CR>")
			-- create new buffer
			Nmap("<A-c>", "<Cmd>enew<CR>")
			-- pick buffer
			Nmap("<A-space>", "<Cmd>BufferLinePick<CR>")
			-- Sort automatically by...
			Nmap("<Space>bd", "<Cmd>BufferLineSortByDirectory<CR>")
			Nmap("<Space>bl", "<Cmd>BufferLineSortByExtension<CR>")
		end,
	})

	-- bottom bar
	use({
		"feline-nvim/feline.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		after = { "catppuccin" },
		config = function()
			require("config/feline")
		end,
	})

	-- DJI Osmo
	use({
		"luukvbaal/stabilize.nvim",
		config = function()
			require("stabilize").setup()
		end,
	})

	-- syntax
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
		config = function()
			require("config/treesitter")
		end,
	})
	use({ "p00f/nvim-ts-rainbow", requires = "nvim-treesitter/nvim-treesitter" })

	-- show possible key combos
	use({
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({})
		end,
	})
	-- we IDE now
	use({
		"rcarriga/nvim-notify",
		config = function()
			require("notify").setup({
				fps = 60,
				timeout = 2500,
				stages = "fade",
			})
		end,
	})

	-- syntax
	use("alker0/chezmoi.vim")
	use("digitaltoad/vim-pug")
	use("ron-rs/ron.vim")
	use("elkowar/yuck.vim")

	-- tooling
	use({
		"editorconfig/editorconfig-vim",
		config = function()
			-- add fugitive buffers to the editorconfig excludes
			vim.g.EditorConfig_exclude_patterns = { "fugitive://.*", "scp://.*" }
		end,
	})
	-- read and write encrypted pgp files
	use("jamessan/vim-gnupg")

	-- additional functionality
	use("tpope/vim-commentary")
	use("tpope/vim-surround")
	use("ggandor/lightspeed.nvim")
	-- make those above work in repeat commands
	use("tpope/vim-repeat")

	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	})
	use({
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	})
	use({
		"heavenshell/vim-jsdoc",
		run = "make install",
		config = function()
			Nmap("<leader>jd", "<Cmd>JsDoc<CR>")
		end,
	})

	-- git
	use("tpope/vim-fugitive")
	-- why not both?
	use({
		"TimUntersberger/neogit",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			Nmap("<leader>ng", "<Cmd>Neogit<CR>")
		end,
	})
	use("christoomey/vim-sort-motion")
	use("dhruvasagar/vim-table-mode")
	use({
		"kyazdani42/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup({ update_cwd = true })
			Nmap("<C-n>", ":NvimTreeToggle<CR>")
			Nmap("<leader>r", ":NvimTreeRefresh<CR>")
		end,
	})
	use({
		"RRethy/vim-hexokinase",
		run = "make",
		config = function()
			vim.g.Hexokinase_highlighters = { "virtual" }
		end,
	})
	use({
		"simrat39/symbols-outline.nvim",
		config = function()
			Nmap("<leader>so", ":SymbolsOutline<CR>")
		end,
	})

	-- databases
	use({
		"kristijanhusak/vim-dadbod-ui",
		requires = "tpope/vim-dadbod",
		config = function()
			Nmap("<leader>db", ":DBUIToggle<CR>")
			vim.g.db_ui_use_nerd_fonts = true
			vim.g.db_ui_win_position = "right"
		end,
	})
	use({
		"kristijanhusak/vim-dadbod-completion",
		requires = { { "tpope/vim-dadbod" }, { "hrsh7th/nvim-cmp" } },
		config = function()
			require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
		end,
	})

	-- telescope
	use({
		"nvim-telescope/telescope.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			-- Find files using Telescope command-line sugar.
			Nmap("<leader>fc", "<cmd>Telescope conventional_commits<CR>")
			Nmap("<leader>fr", "<cmd>Telescope asynctasks all<CR>")
			Nmap("<leader>ff", "<cmd>Telescope find_files<CR>")
			Nmap("<leader>fg", "<cmd>Telescope live_grep<CR>")
			Nmap("<leader>fb", "<cmd>Telescope buffers<CR>")
			Nmap("<leader>fh", "<cmd>Telescope help_tags<CR>")
		end,
	})
	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		run = "make",
		requires = "nvim-telescope/telescope.nvim",
		config = function()
			local telescope = require("telescope")
			telescope.setup({
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})
			telescope.load_extension("fzf")
		end,
	})
	use({
		"nvim-telescope/telescope-file-browser.nvim",
		config = function()
			require("telescope").load_extension("file_browser")
		end,
	})
	use({
		"nvim-telescope/telescope-project.nvim",
		config = function()
			require("telescope").load_extension("project")
		end,
	})
	use({
		"olacin/telescope-cc.nvim",
		requires = {
			{ "nvim-telescope/telescope.nvim" },
			{ "nvim-lua/popup.nvim" },
		},
		config = function()
			require("telescope").load_extension("conventional_commits")
		end,
	})
	use({
		"sudormrfbin/cheatsheet.nvim",
	})

	use({
		"andweeb/presence.nvim",
		config = function()
			require("config/presence")
		end,
	})
	use({ "iamcco/markdown-preview.nvim", run = "cd app && yarn install" })

	-- external extensions
	use("williamboman/mason.nvim")
	-- LSP
	use("williamboman/mason-lspconfig.nvim")
	use("neovim/nvim-lspconfig")
	-- completion
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-vsnip")
	use("hrsh7th/vim-vsnip")
	use("petertriho/cmp-git")
	-- other
	use({
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.gofmt,
					null_ls.builtins.formatting.prettier,
					null_ls.builtins.formatting.rustfmt,
					null_ls.builtins.formatting.stylua,
				},
			})
		end,
		requires = { "nvim-lua/plenary.nvim" },
	})

	use({
		"simrat39/rust-tools.nvim",
		config = function()
			require("rust-tools").setup({})
		end,
	})
	use("b0o/schemastore.nvim")
	--
	use({
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup({})
		end,
	})
	use({
		"glepnir/lspsaga.nvim",
		config = function()
			require("config/lspsaga")
		end,
	})
	--
	use({
		"github/copilot.vim",
		config = function()
			Imap("<C-J>", "copilot#Accept(<Tab>)", { noremap = true, silent = true, expr = true })
			vim.g.copilot_no_tab_map = true
		end,
	})

	-- organization
	use({
		"vimwiki/vimwiki",
		branch = "dev",
		config = function()
			vim.g.vimwiki_global_ext = 0
			vim.g.vimwiki_list = {
				{
					auto_export = 1,
					path_html = "~/.local/share/vimwiki/",
					path = "~/.local/share/vimwiki/",
					syntax = "markdown",
					ext = ".md",
				},
			}
		end,
	})
	use("tools-life/taskwiki")
	use({
		"skywind3000/asyncrun.vim",
		config = function()
			vim.g.asyncrun_open = 6
		end,
	})
	use({ "skywind3000/asynctasks.vim" })
	use({
		"GustavoKatel/telescope-asynctasks.nvim",
		config = function()
			require("telescope").load_extension("asynctasks")
		end,
	})

	-- startup
	use({
		"glepnir/dashboard-nvim",
		config = function()
			require("config/dashboard")
		end,
	})

	-- automatic theme switching
	use({
		"f-person/auto-dark-mode.nvim",
		config = function()
			local auto_dark_mode = require("auto-dark-mode")
			auto_dark_mode.setup({
				---@diagnostic disable-next-line: assign-type-mismatch
				update_interval = 5000,
				set_dark_mode = function()
					vim.cmd("Catppuccin mocha")
				end,
				set_light_mode = function()
					vim.cmd("Catppuccin latte")
				end,
			})
			auto_dark_mode.init()
		end,
		cond = vim.fn.has("macunix"),
	})
end)
