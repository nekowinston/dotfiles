local telescope = require("telescope")

telescope.setup({
  defaults = {
    selection_caret = "▶ ",
    borderchars = { '═', '║', '═', '║', '╔', '╗', '╝', '╚' },
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


local easypick = require("easypick")
easypick.setup({
  pickers = {
    {
      name = "chezmoi",
      command = [[chezmoi managed -ifiles -pabsolute -xencrypted]],
      previewer = easypick.previewers.default()
    },
  }
})


telescope.load_extension("fzf")
