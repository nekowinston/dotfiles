local present, indent_blankline = pcall(require, "indent_blankline")
if not present then
  return
end

indent_blankline.setup({
  space_char_blankline = " ",
})
vim.g.indent_blankline_filetype_exclude = {
  "dashboard",
  "fugitive",
  "help",
  "lazy",
  "NvimTree",
  "neogitstatus",
  "Trouble",
}
