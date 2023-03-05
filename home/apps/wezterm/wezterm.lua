local wezterm = require("wezterm")

local c = wezterm.config_builder()
c:set_strict_mode(true)

require("fonts").apply(c)
require("keys").apply(c)
require("theme").apply(c)

-- set up terminfo on nix
c.set_environment_variables = {
  TERMINFO_DIRS = wezterm.home_dir .. "/.nix-profile/share/terminfo",
}
-- window
c.window_decorations = "RESIZE"
c.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
-- dim unfocused panes
c.inactive_pane_hsb = {
  saturation = 1.0,
  brightness = 0.6,
}
-- etc.
c.adjust_window_size_when_changing_font_size = false
c.audible_bell = "Disabled"
c.clean_exit_codes = { 130 }
c.default_cursor_style = "BlinkingBar"

require("bar").apply_to_config(c)

return c
