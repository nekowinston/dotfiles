local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

local plugins = {
  { "catppuccin/nvim", name = "catppuccin" },
  "pocco81/true-zen.nvim",
  "lewis6991/gitsigns.nvim",
  "lukas-reineke/indent-blankline.nvim",
  "akinsho/bufferline.nvim",
  "feline-nvim/feline.nvim",
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      theme = "catppuccin",
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
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "kyazdani42/nvim-web-devicons",
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
      "https://github.com/folke/trouble.nvim",
      { "j-hui/fidget.nvim", opts = {} },
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
}

require("lazy").setup(plugins, {
  install = { colorscheme = { "catppuccin" } },
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "bugreport",
        "compiler",
        "ftplugin",
        "fzf",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "matchit",
        "netrw",
        "netrwFileHandlers",
        "netrwPlugin",
        "netrwSettings",
        "optwin",
        "rplugin",
        "rrhelper",
        "spellfile_plugin",
        "synmenu",
        "syntax",
        "tar",
        "tarPlugin",
        "tutor",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
      },
    },
  },
  ui = {
    icons = {
      cmd = " ",
      config = "",
      event = " ",
      ft = " ",
      init = " ",
      keys = " ",
      plugin = " ",
      runtime = " ",
      source = " ",
      start = " ",
      task = " ",
    },
    border = "double",
  },
})
