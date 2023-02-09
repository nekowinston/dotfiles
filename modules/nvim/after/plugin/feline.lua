local get_config = function()
  -- unload these if loaded, so that theme switching works
  package.loaded["feline"] = nil
  package.loaded["catppuccin.groups.integrations.feline"] = nil

  local present, feline = pcall(require, "feline")
  local ctp_present, ctp_feline =
    pcall(require, "catppuccin.groups.integrations.feline")

  if not (present and ctp_present) then
    return
  end

  local clrs = require("catppuccin.palettes").get_palette()
  ctp_feline.setup({
    assets = {
      left_separator = "",
      right_separator = "",
      bar = "█",
      mode_icon = " ",
      dir = " ",
      file = " ",
      git = {
        branch = " ",
        added = " ",
        changed = " ",
        removed = " ",
      },
      lsp = {
        server = " ",
        error = " ",
        warning = " ",
        info = " ",
        hint = " ",
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
end

get_config()

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    get_config()
  end,
})
