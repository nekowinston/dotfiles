local wezterm = require("wezterm")
local c = wezterm.config_builder()
local utils = require("config.utils")

require("config.font-switcher").apply(c, {
  fonts = {
    {
      label = "Berkeley Mono",
      font = "TX-02",
    },
    { font = "Cascadia Code" },
    { font = "Comic Code Ligatures" },
    { font = "IBM Plex Mono" },
    { font = "Intel One Mono" },
    { font = "JetBrains Mono" },
    { font = "Monaspace Argon" },
    { font = "Monaspace Krypton" },
    { font = "Monaspace Neon" },
    { font = "Monaspace Radon" },
    { font = "Monaspace Xenon" },
  },
})
require("config.keys").apply(c)
require("config.systemd").apply(c)
require("config.zen-mode")

c.front_end = "WebGpu"

if utils.is_darwin() then
  c.window_decorations = "RESIZE|INTEGRATED_BUTTONS"
  c.window_padding = { left = 0, right = 0, top = 50, bottom = 0 }
else
  if os.getenv("XDG_CURRENT_DESKTOP") == "sway" then
    c.window_decorations = "NONE"
  end
  c.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
end

c.adjust_window_size_when_changing_font_size = false
c.audible_bell = "Disabled"
c.cursor_blink_rate = 0
c.default_cursor_style = "SteadyBar"
c.inactive_pane_hsb = { brightness = 0.90 }

require("bar.plugin").apply_to_config(c)
require("milspec.plugin").apply_to_config(c, { sync = true })

return c
