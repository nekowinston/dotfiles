local packer = require("packer")

-- auto-compile when lua files in `~/.config/nvim/*` change
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.lua",
  callback = function()
    local cfg_path = vim.fn.resolve(vim.fn.stdpath("config"))
    vim.defer_fn(function()
      if vim.fn.expand("%:p"):match(cfg_path) then
        vim.cmd("silent! PackerCompile")
      end
    end, 0)
  end,
})

return packer.startup({
  function(use)
    -- Packer managing itself
    use("wbthomason/packer.nvim")
    -- startup time or some shit
    use("lewis6991/impatient.nvim")

    -- colour scheme
    use({
      "catppuccin/nvim",
      as = "catppuccin",
      config = function()
        require("config/catppuccin")
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
        require("indent_blankline").setup({})
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
        require("config/bufferline")
      end,
    })

    use({
      "nvim-lualine/lualine.nvim",
      requires = { "kyazdani42/nvim-web-devicons", opt = true },
      config = function()
        require("lualine").setup({
          options = {
            theme = "catppuccin",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
          },
        })
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
      run = function()
        require("nvim-treesitter.install").update({ with_sync = true })
      end,
      config = function()
        require("config/treesitter")
      end,
    })
    use("nvim-treesitter/playground")

    use({
      "p00f/nvim-ts-rainbow",
      requires = "nvim-treesitter/nvim-treesitter",
    })

    -- show possible key combos
    use({
      "folke/which-key.nvim",
      config = function()
        require("which-key").setup({})
      end,
    })

    -- syntax
    use("alker0/chezmoi.vim")
    -- tooling
    use("gpanders/editorconfig.nvim")
    -- read and write encrypted pgp files
    use("jamessan/vim-gnupg")

    -- additional functionality
    use({
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup()
      end,
    })
    use({
      "kylechui/nvim-surround",
      config = function()
        require("nvim-surround").setup({})
      end,
    })
    use("ggandor/lightspeed.nvim")

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

    -- git
    use("tpope/vim-fugitive")
    -- why not both?
    use({
      "TimUntersberger/neogit",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        Map("n", "<leader>ng", "<Cmd>Neogit<CR>")
      end,
    })
    use("dhruvasagar/vim-table-mode")
    use({
      "nvchad/nvim-colorizer.lua",
      config = function()
        require("config/colorizer")
      end,
    })
    use({
      "simrat39/symbols-outline.nvim",
      config = function()
        require("symbols-outline").setup()
        Map("n", "<leader>so", ":SymbolsOutline<CR>")
      end,
    })

    -- databases
    use("tpope/vim-dadbod")
    use("kristijanhusak/vim-dadbod-completion")
    use({
      "kristijanhusak/vim-dadbod-ui",
      config = function()
        Map("n", "<leader>db", ":DBUIToggle<CR>")
        vim.g.db_ui_use_nerd_fonts = true
        vim.g.db_ui_win_position = "right"
      end,
    })

    -- telescope
    use({
      "nvim-telescope/telescope.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("telescope").setup({
          defaults = {
            borderchars = {
              "═",
              "║",
              "═",
              "║",
              "╔",
              "╗",
              "╝",
              "╚",
            },
          },
        })
        Map("n", "<leader>fr", "<cmd>Telescope asynctasks all<CR>")
        Map("n", "<leader>fb", "<cmd>Telescope file_browser<CR>")
        Map("n", "<leader>fd", "<cmd>Telescope find_files<CR>")
        Map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")
        Map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>")
        Map("n", "<leader>fp", "<cmd>Telescope project<CR>")
        Map("n", "<leader>fs", function()
          local confpath = vim.fn.resolve(vim.fn.stdpath("config"))
          require("telescope.builtin").find_files({ cwd = confpath })
        end)
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
      "andweeb/presence.nvim",
      config = function()
        require("config/presence")
      end,
    })
    use({ "iamcco/markdown-preview.nvim", run = "cd app && yarn install" })

    -- LSP
    use("williamboman/mason.nvim")
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
    use("onsails/lspkind.nvim")
    use("rafamadriz/friendly-snippets")
    use("jose-elias-alvarez/null-ls.nvim")
    use({
      "glepnir/lspsaga.nvim",
      branch = "main",
      config = function()
        require("config/lspsaga")
      end,
    })
    use({ "barreiroleo/ltex-extra.nvim" })

    use("b0o/schemastore.nvim")
    use({
      "github/copilot.vim",
      config = function()
        local opt = { noremap = true, silent = true, expr = true }
        Map("i", "<C-J>", 'copilot#Accept("<CR>")', opt)
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
            path = "~/.local/share/vimwiki/",
            syntax = "markdown",
            ext = ".md",
            path_html = "~/vimwiki/",
            template_path = "~/.config/vimwiki/templates/",
            template_default = "default",
            template_ext = ".tpl",
            custom_wiki2html = "vimwiki_markdown",
            html_filename_parameterization = 1,
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
  end,
  config = {
    display = {
      open_fn = function()
        return require("packer.util").float({ border = "double" })
      end,
    },
  },
})
