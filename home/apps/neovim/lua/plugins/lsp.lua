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
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "petertriho/cmp-git",
      "onsails/lspkind.nvim",
      "rafamadriz/friendly-snippets",
      "jose-elias-alvarez/null-ls.nvim",
      {
        "folke/trouble.nvim",
        opts = { padding = false },
      },
      { "folke/neodev.nvim", opts = {} },
      "nvim-lua/lsp-status.nvim",
      "barreiroleo/ltex-extra.nvim",
      "b0o/schemastore.nvim",
      "hallerpatrick/py_lsp.nvim",
      "simrat39/rust-tools.nvim",
      "pmizio/typescript-tools.nvim",
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
}
