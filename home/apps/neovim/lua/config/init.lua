require("config.autocmds")
require("config.mappings")
require("config.options")

local plugins = {
  { "catppuccin/nvim", name = "catppuccin" },
  "pocco81/true-zen.nvim",
  "lewis6991/gitsigns.nvim",
  "lukas-reineke/indent-blankline.nvim",
  "akinsho/bufferline.nvim",
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "SmiteshP/nvim-navic",
    },
  },
  "luukvbaal/stabilize.nvim",
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
  },
  "nvim-treesitter/playground",
  "windwp/nvim-ts-autotag",
  "HiPhish/nvim-ts-rainbow2",
  -- syntax
  {
    "wuelnerdotexe/vim-astro",
    config = function()
      vim.g.astro_typescript = "enable"
    end,
  },
  "noahtheduke/vim-just",

  { "numtostr/comment.nvim", opts = {} },
  "gpanders/editorconfig.nvim",
  "ggandor/lightspeed.nvim",
  "windwp/nvim-autopairs",
  "nvchad/nvim-colorizer.lua",
  { "kylechui/nvim-surround", opts = {} },
  { "folke/todo-comments.nvim", opts = {} },
  "jamessan/vim-gnupg",
  {
    "dhruvasagar/vim-table-mode",
    config = function()
      vim.cmd([[autocmd FileType markdown let g:table_mode_corner='|']])
    end,
  },
  "folke/which-key.nvim",
  "f-person/auto-dark-mode.nvim",

  -- git
  "tpope/vim-fugitive",
  "TimUntersberger/neogit",

  -- databases
  "tpope/vim-dadbod",
  "kristijanhusak/vim-dadbod-completion",
  {
    "kristijanhusak/vim-dadbod-ui",
    config = function()
      vim.g.db_ui_use_nerd_fonts = true
      vim.g.db_ui_win_position = "right"
    end,
  },

  "skywind3000/asyncrun.vim",
  "skywind3000/asynctasks.vim",

  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "GustavoKatel/telescope-asynctasks.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-project.nvim",
    },
  },

  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
  },

  -- nvimtree
  "nvim-tree/nvim-web-devicons",
  "nvim-tree/nvim-tree.lua",

  "stevearc/dressing.nvim",

  -- discord
  "andweeb/presence.nvim",
  { "iamcco/markdown-preview.nvim", build = "cd app && yarn install" },

  "towolf/vim-helm",
  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- completion
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "petertriho/cmp-git",
      "onsails/lspkind.nvim",
      "rafamadriz/friendly-snippets",
      "jose-elias-alvarez/null-ls.nvim",
      "folke/trouble.nvim",
      "nvim-lua/lsp-status.nvim",
      "j-hui/fidget.nvim",
      "barreiroleo/ltex-extra.nvim",
      "b0o/schemastore.nvim",
      "hallerpatrick/py_lsp.nvim",
      "simrat39/rust-tools.nvim",
      { "ray-x/go.nvim", dependencies = { "ray-x/guihua.lua" } },
      {
        "rcarriga/nvim-dap-ui",
        dependencies = {
          "mfussenegger/nvim-dap",
          "theHamsta/nvim-dap-virtual-text",
        },
      },
    },
    config = function()
      require("lsp")
    end,
  },

  -- lua github copilot
  "zbirenbaum/copilot.lua",

  { "nvim-neorg/neorg", build = ":Neorg sync-parsers" },
}

require("config.plugins").setup(plugins)
