local clrs = require("catppuccin.palettes.init").get_palette()
local ctp_feline = require("catppuccin.groups.integrations.feline")

ctp_feline.setup({
  assets = {
    left_separator = "",
    right_separator = "",
    bar = "█",
    mode_icon = " ",
    dir = "  ",
    file = "   ",
    git = {
      branch = " ",
    },
  },
  sett = {
    show_modified = true,
    curr_dir = clrs.mauve,
    curr_file = clrs.blue,
  },
  mode_colors = {
    ["n"] = { "NORMAL", clrs.blue },
  },
})

require("feline").setup({
  components = ctp_feline.get(),
  force_inactive = {
    filetypes = {
      "^packer$",
      "^startify$",
      "^fugitive$",
      "^fugitiveblame$",
      "^qf$",
      "^help$",
    },
    buftypes = {
      "^terminal$",
    },
    bufnames = {},
  },
})
