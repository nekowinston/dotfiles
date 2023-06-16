---@type LazyPluginSpec[]
return {
  {
    "nvchad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false,
        RRGGBBAA = true,
        AARRGGBB = false,
        rgb_fn = false,
        hsl_fn = false,
        css = false,
        css_fn = false,
        mode = "background",
        tailwind = "both",
        sass = { enable = true },
        virtualtext = " ",
      },
      buftypes = {
        "*",
        "!dashboard",
        "!lazy",
        "!popup",
        "!prompt",
      },
    },
    { "ziontee113/color-picker.nvim", opts = {} },
  },
}
