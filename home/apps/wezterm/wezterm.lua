local wezterm = require("wezterm")
local c = wezterm.config_builder()
local utils = require("config.utils")

require("config.keys").apply(c)

c.default_prog = { "nu" }

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

require("catppuccin.plugin").apply_to_config(c, { sync = true })

return c
