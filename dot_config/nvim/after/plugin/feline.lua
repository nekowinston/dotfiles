local ctp_present, clrs = pcall(require, "catppuccin.palettes")
local _, ctp_feline = pcall(require, "catppuccin.groups.integrations.feline")
local present, feline = pcall(require, "feline")

if not present then
  return
end

if ctp_present then
  clrs = clrs.get_palette("catppuccin")
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
      bkg = clrs.crust,
    },
    mode_colors = {
      ["n"] = { "NORMAL", clrs.blue },
    },
  })
end

feline.setup({
  components = ctp_feline.get(),
  force_inactive = {
    filetypes = {
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
