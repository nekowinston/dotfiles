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

local function check_git()
  local is_repo = vim.fn.filereadable(vim.fn.getcwd() .. "/.git") == 1
  local git_exists = vim.fn.executable("git") == 1
  return is_repo and git_exists
end

return packer.startup({
  function(use)
    -- Packer managing itself
    use("wbthomason/packer.nvim")
    -- startup time or some shit
    use("lewis6991/impatient.nvim")

    -- colour scheme
    use({
      "https://git.winston.sh/catppuccin/nvim",
      as = "catppuccin",
      config = function()
        require("config/catppuccin")
      end,
    })

    use({
      "Pocco81/true-zen.nvim",
      config = function()
        require("true-zen").setup()
      end,
    })

    -- git gutter
    use({
      "lewis6991/gitsigns.nvim",
      config = function()
        require("config/gitsigns")
      end,
      cond = check_git,
    })
    -- rainbow indents
    use({
      "lukas-reineke/indent-blankline.nvim",
      config = function()
        require("indent_blankline").setup({
          space_char_blankline = " ",
          -- show_current_context = true,
          -- show_current_context_start = true,
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

    use({
      "akinsho/bufferline.nvim",
      config = function()
        require("config/bufferline")
      end,
    })

    use({
      "feline-nvim/feline.nvim",
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
        require("config/which-key")
      end,
    })

    -- syntax
    use("alker0/chezmoi.vim")
    use({
      "wuelnerdotexe/vim-astro",
      config = function()
        vim.g.astro_typescript = "enable"
      end,
    })
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
    use({
      "tpope/vim-fugitive",
      cond = check_git,
    })
    -- why not both?
    use({
      "TimUntersberger/neogit",
      requires = "nvim-lua/plenary.nvim",
      cond = check_git,
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
        require("config/telescope")
      end,
    })
    use({
      "nvim-telescope/telescope-fzf-native.nvim",
      run = "make",
      requires = "nvim-telescope/telescope.nvim",
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

    use("nvim-tree/nvim-web-devicons")
    use({
      "nvim-tree/nvim-tree.lua",
      keys = { "<C-n>" },
      config = function()
        Map("n", "<C-N>", ":NvimTreeToggle<CR>")
        require("nvim-tree").setup()
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
    use({
      "ray-x/go.nvim",
      requires = "ray-x/guihua.lua",
    })
    use({
      "HallerPatrick/py_lsp.nvim",
    })
    use({
      "simrat39/rust-tools.nvim",
    })

    use({
      "rcarriga/nvim-dap-ui",
      requires = {
        "mfussenegger/nvim-dap",
        "theHamsta/nvim-dap-virtual-text",
      },
    })

    use({ "barreiroleo/ltex-extra.nvim" })

    use("b0o/schemastore.nvim")
    use({
      "zbirenbaum/copilot.lua",
      config = function()
        require("config/copilot")
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
  end,
  config = {
    display = {
      open_fn = function()
        return require("packer.util").float({ border = "double" })
      end,
    },
  },
})
