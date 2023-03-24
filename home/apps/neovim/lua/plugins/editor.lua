return {
  -- TODO: remove in nvim 0.9 because of upstream merge
  "luukvbaal/stabilize.nvim",
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
  {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      markdown = {
        dash_string = "═",
        quote_string = "┃",
        fat_headline_upper_string = "▃",
        fat_headline_lower_string = "🬂",
      },
    },
  },
}
