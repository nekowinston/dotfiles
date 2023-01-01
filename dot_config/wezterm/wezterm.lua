local wezterm = require("wezterm")
local fonts = require("fonts")
local theme = require("theme")
require("bar")

local font = fonts.get_font("berkeley")

-- wezterm.GLOBAL.smart_padding = {
--   left = 12,
--   right = 12,
--   top = 0,
--   bottom = 0,
-- }

return {
  -- keys
  disable_default_key_bindings = true,
  leader = { key = "s", mods = "CTRL", timeout_milliseconds = 5000 },
  keys = require("shortcuts"),
  -- font
  font = font.font,
  font_size = font.size,
  -- window
  window_decorations = "RESIZE",
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  inactive_pane_hsb = {
    saturation = 1.0,
    brightness = 0.6,
  },
  -- theme
  color_schemes = theme.get_custom_colorschemes(),
  color_scheme = theme.scheme_for_appearance(wezterm.gui.get_appearance(), {
    dark = "OLEDppuccin",
    light = "Catppuccin Latte",
  }),
  -- tab bar
  tab_bar_at_bottom = true,
  tab_max_width = 32,
  use_fancy_tab_bar = false,
  -- etc.
  adjust_window_size_when_changing_font_size = false,
  use_resize_increments = true,
  audible_bell = "Disabled",
  clean_exit_codes = { 130 },
  default_cursor_style = "BlinkingBar",
  enable_scroll_bar = false,
}
