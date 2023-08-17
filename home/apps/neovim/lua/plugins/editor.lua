---@type LazyPluginSpec[]
return {
  -- zen mode
  "pocco81/true-zen.nvim",
  -- respect project settings
  "gpanders/editorconfig.nvim",
  -- best hop
  {
    "folke/flash.nvim",
    opts = {},
    -- stylua: ignore
    keys = {
      {
        "s", mode = { "n", "x", "o" }, desc = "Flash",
        function() require("flash").jump() end,
      },
      {
        "S", mode = { "n", "o", "x" }, desc = "Flash Treesitter",
        function() require("flash").treesitter() end,
      },
      {
        "r", mode = "o", desc = "Remote Flash",
        function() require("flash").remote() end,
      },
      {
        "R", mode = { "o", "x" }, desc = "Treesitter Search",
        function() require("flash").treesitter_search() end,
      },
      {
        "<c-f>", mode = { "c" }, desc = "Toggle Flash Search",
        function() require("flash").toggle() end,
      },
    },
  },
  -- run tasks
  "skywind3000/asyncrun.vim",
  "skywind3000/asynctasks.vim",
  -- ui
  "stevearc/dressing.nvim",
  -- highlight todo/fixme/etc
  { "folke/todo-comments.nvim", opts = {} },
  -- pretty much default nvim at this point
  { "kylechui/nvim-surround", opts = {} },
  { "numtostr/comment.nvim", opts = {} },
  --
  {
    "AndrewRadev/tagalong.vim",
    config = function()
      vim.g.tagalong_filetypes = {
        "astro",
        "ejs",
        "html",
        "htmldjango",
        "javascriptreact",
        "jsx",
        "php",
        "typescriptreact",
        "xml",
      }
    end,
  },
  {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {},
  },
  { "dnlhc/glance.nvim", opts = {} },
}
