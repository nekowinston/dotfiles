require("indent_blankline").setup({
  space_char_blankline = " ",
})
vim.g.indent_blankline_filetype_exclude = {
  "dashboard",
  "help",
  "neogitstatus",
  "fugitive",
  "NvimTree",
  "Trouble",
}
