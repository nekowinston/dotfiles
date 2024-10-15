local wezterm = require("wezterm")
local c = wezterm.config_builder()

require("config.keys").apply(c)
require("config.font-switcher").apply(c)
require("config.zen-mode")

c.front_end = "WebGpu"
c.font_size = 13
c.harfbuzz_features = { "calt=1", "ss01=1" }
c.command_palette_font_size = c.font_size * 1.1
c.window_frame = { font = wezterm.font("IBM Plex Sans") }

c.window_background_opacity = 0.95
c.macos_window_background_blur = 20

c.default_prog = { "/etc/profiles/per-user/winston/bin/nu", "-l" }

c.window_decorations = "RESIZE|INTEGRATED_BUTTONS"
c.window_padding = { left = 0, right = 0, top = 50, bottom = 0 }
c.adjust_window_size_when_changing_font_size = false
c.audible_bell = "Disabled"
c.default_cursor_style = "BlinkingBar"
c.inactive_pane_hsb = { brightness = 0.90 }

require("bar.plugin").apply_to_config(c)
require("milspec.plugin").apply_to_config(c, { sync = true })

return c
