return {
  "tpope/vim-dadbod",
  "kristijanhusak/vim-dadbod-completion",
  {
    "kristijanhusak/vim-dadbod-ui",
    config = function()
      vim.g.db_ui_use_nerd_fonts = true
      vim.g.db_ui_win_position = "right"
    end,
  },
}
