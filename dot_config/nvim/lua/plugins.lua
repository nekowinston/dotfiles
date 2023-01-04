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

vim.api.nvim_create_user_command("LazySyncOneshot", function()
  require("lazy").sync({ wait = true })
  vim.cmd("qa")
end, {})

local plugins = {
  -- startup time or some shit
  "lewis6991/impatient.nvim",
  -- colour scheme
  { "catppuccin/nvim", name = "catppuccin" },
  "glepnir/dashboard-nvim",
  "Pocco81/true-zen.nvim",
  -- git gutter
  "lewis6991/gitsigns.nvim",
  -- rainbow indents
  "lukas-reineke/indent-blankline.nvim",
  "akinsho/bufferline.nvim",
  "feline-nvim/feline.nvim",
  -- DJI Osmo
  "luukvbaal/stabilize.nvim",
  -- syntax
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
  },
  "nvim-treesitter/playground",
  "p00f/nvim-ts-rainbow",
  -- show possible key combos
  "folke/which-key.nvim",
  -- syntax
  "alker0/chezmoi.vim",
  {
    "wuelnerdotexe/vim-astro",
    config = function()
      vim.g.astro_typescript = "enable"
    end,
  },
  -- tooling
  "gpanders/editorconfig.nvim",
  -- read and write encrypted pgp files
  "jamessan/vim-gnupg",
  -- additional functionality
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup()
    end,
  },
  "ggandor/lightspeed.nvim",
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
  "windwp/nvim-ts-autotag",
  -- git
  "tpope/vim-fugitive",
  -- why not both?
  "TimUntersberger/neogit",
  {
    "dhruvasagar/vim-table-mode",
    config = function()
      vim.cmd([[autocmd FileType markdown let g:table_mode_corner='|']])
    end,
  },
  "nvchad/nvim-colorizer.lua",
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
      "axkirillov/easypick.nvim",
    },
  },

  -- nvimtree
  "nvim-tree/nvim-web-devicons",
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup()
    end,
  },

  -- discord
  "andweeb/presence.nvim",
  { "iamcco/markdown-preview.nvim", build = "cd app && yarn install" },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
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
      "glepnir/lspsaga.nvim",
      {
        "j-hui/fidget.nvim",
        config = function()
          require("fidget").setup({})
        end,
      },
      "barreiroleo/ltex-extra.nvim",
      "b0o/schemastore.nvim",
      "HallerPatrick/py_lsp.nvim",
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
  },
  -- lua github copilot
  "zbirenbaum/copilot.lua",
}

require("lazy").setup(plugins, {
  defaults = { lazy = false },
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
