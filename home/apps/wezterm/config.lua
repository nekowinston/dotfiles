local wezterm = require("wezterm")

local c = {}
if wezterm.config_builder then
  c = wezterm.config_builder()
  c:set_strict_mode(true)
end

require("fonts").apply(c)
require("keys").apply(c)
c.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

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
c.launch_menu = {
  { label = "Music player", args = { "ncmpcpp" } },
}
c.command_palette_font_size = 16.0
c.window_background_opacity = 0.9
c.window_frame = {
  font_size = 18.0,
}

wezterm.plugin
  .require("https://github.com/catppuccin/wezterm")
  .apply_to_config(c, {
    flavor = "mocha",
    sync = wezterm.target_triple:find("darwin") ~= nil,
    sync_flavors = { light = "latte", dark = "mocha" },
  })
wezterm.plugin
  .require("https://github.com/nekowinston/wezterm-bar")
  .apply_to_config(c, {
    indicator = {
      leader = { off = "", on = "" },
    },
  })

return c
