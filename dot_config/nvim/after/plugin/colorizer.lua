local present, colorizer = pcall(require, "colorizer")
if not present then return end

colorizer.setup({
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
})
