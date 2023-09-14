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
      { "folke/neodev.nvim", opts = true },
      "nvim-lua/lsp-status.nvim",
      "barreiroleo/ltex-extra.nvim",
      "b0o/schemastore.nvim",
      "hallerpatrick/py_lsp.nvim",
      -- rust lsp, dap, dependency management
      { "saecki/crates.nvim", opts = true },
      "simrat39/rust-tools.nvim",
      -- lua native typescript lsp plugin
      "pmizio/typescript-tools.nvim",
      { "ray-x/go.nvim", dependencies = { "ray-x/guihua.lua" } },
      {
        "mfussenegger/nvim-dap",
        dependencies = {
          { "rcarriga/nvim-dap-ui" },
          "theHamsta/nvim-dap-virtual-text",
        },
        config = function()
          local dap, dapui = require("dap"), require("dapui")

          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
          end
        end,
      },
    },
    config = function()
      require("lsp")
    end,
  },
}
