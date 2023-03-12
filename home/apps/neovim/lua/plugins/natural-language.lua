return {
  {
    "dhruvasagar/vim-table-mode",
    config = function()
      vim.cmd([[autocmd FileType markdown let g:table_mode_corner='|']])
    end,
  },
  "jamessan/vim-gnupg",
  { "iamcco/markdown-preview.nvim", build = "cd app && yarn install" },
}
