---@type LazyPluginSpec[]
return {
  -- zen mode
  "pocco81/true-zen.nvim",
  -- respect project settings
  "gpanders/editorconfig.nvim",
  -- best hop
  "ggandor/lightspeed.nvim",
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
