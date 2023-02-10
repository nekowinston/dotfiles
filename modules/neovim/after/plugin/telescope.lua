local present, telescope = pcall(require, "telescope")
if not present then
  return
end

pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "asynctasks")
pcall(telescope.load_extension, "file_browser")
pcall(telescope.load_extension, "project")

telescope.setup({
  defaults = {
    selection_caret = "▶ ",
    borderchars = { "═", "║", "═", "║", "╔", "╗", "╝", "╚" },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})
