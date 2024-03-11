local wezterm = require("wezterm")
local c = wezterm.config_builder()
local utils = require("config.utils")

require("config.keys").apply(c)

c.font = wezterm.font_with_fallback({
  "Berkeley Mono",
  "Symbols Nerd Font",
})
c.front_end = "WebGpu"
c.font_size = 13
c.harfbuzz_features = { "calt=1", "ss01=1" }
c.command_palette_font_size = c.font_size * 1.1
c.window_frame = {
  font = wezterm.font("IBM Plex Sans"),
  font_size = c.font_size,
}

c.window_decorations = "RESIZE|INTEGRATED_BUTTONS"
c.window_padding = { left = 0, right = 0, top = 50, bottom = 0 }
c.adjust_window_size_when_changing_font_size = false
c.audible_bell = "Disabled"
c.default_cursor_style = "BlinkingBar"
c.inactive_pane_hsb = { brightness = 0.90 }

-- some annoying bug is causing crashes on sway
if utils.is_darwin() then
  require("bar.plugin").apply_to_config(c)
end

require("catppuccin.plugin").apply_to_config(c, {
  color_overrides = {
    mocha = {
      rosewater = "#ece3e1",
      flamingo = "#e1d2d2",
      pink = "#ddccd8",
      mauve = "#bbb2c9",
      red = "#c4a2aa",
      maroon = "#cbadb1",
      peach = "#d5beb4",
      yellow = "#ece3d3",
      green = "#b9ddb6",
      teal = "#badad4",
      sky = "#b8d4db",
      sapphire = "#a9c0ce",
      blue = "#aab3c7",
      lavender = "#bfc1d2",
      text = "#d3d6e1",
      subtext1 = "#bec2d2",
      subtext0 = "#a8adc3",
      overlay2 = "#9299b4",
      overlay1 = "#7c84a5",
      overlay0 = "#686f94",
      surface2 = "#555a7b",
      surface1 = "#434664",
      surface0 = "#30314b",
      base = "#101010",
      mantle = "#090909",
      crust = "#080808",
    },
  },
  sync = true,
})

return c
