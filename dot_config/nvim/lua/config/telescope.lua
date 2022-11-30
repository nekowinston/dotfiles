local telescope = require("telescope")

telescope.setup({
  defaults = {
    selection_caret = "▶ ",
    borderchars = {
      results = {
        "═",
        "│",
        " ",
        "║",
        "╔",
        "╤",
        "│",
        "║",
      },
      prompt = {
        "─",
        "│",
        "═",
        "║",
        "╟",
        "┤",
        "╧",
        "╚",
      },
      preview = {
        "═",
        "║",
        "═",
        " ",
        "═",
        "╗",
        "╝",
        "═",
      },
    },
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

telescope.load_extension("fzf")
