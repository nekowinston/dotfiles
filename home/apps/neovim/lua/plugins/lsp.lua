---@type LazyPluginSpec[]
return {
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
      {
        "folke/trouble.nvim",
        opts = { padding = false },
      },
      "nvim-lua/lsp-status.nvim",
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
  "towolf/vim-helm",
}
