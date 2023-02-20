local wezterm = require("wezterm")
local fonts = require("fonts")
local theme = require("theme")
local shortcuts = require("shortcuts")
require("bar")

local font = fonts.get_font("berkeley")
wezterm.GLOBAL = {
  enable_tab_bar = true,
}

return {
  set_environment_variables = {
    TERMINFO_DIRS = wezterm.home_dir .. "/.nix-profile/share/terminfo",
  },
  -- keys
  disable_default_key_bindings = true,
  leader = { key = "s", mods = "CTRL", timeout_milliseconds = 5000 },
  term = "wezterm",
  keys = shortcuts,
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
    dark = "Catppuccin Americano",
    light = "Catppuccin Latte",
  }),
  -- tab bar
  tab_bar_at_bottom = true,
  tab_max_width = 32,
  use_fancy_tab_bar = false,
  window_background_opacity = 1.00,
  hide_tab_bar_if_only_one_tab = false,
  enable_tab_bar = wezterm.GLOBAL.tab_bar_hidden,
  -- etc.
  adjust_window_size_when_changing_font_size = false,
  use_resize_increments = false,
  audible_bell = "Disabled",
  clean_exit_codes = { 130 },
  default_cursor_style = "BlinkingBar",
  enable_scroll_bar = false,
}
