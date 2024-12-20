local wezterm = require("wezterm")
local c = wezterm.config_builder()
local utils = require("config.utils")

require("config.font-switcher").apply(c, {
  fonts = {
    { font = "BerkeleyMono Nerd Font" },
    { font = "BlexMono Nerd Font" },
    { font = "CaskaydiaMonoNF Nerd Font" },
    { font = "ComicCodeLigatures Nerd Font" },
    { font = "IntoneMono Nerd Font" },
    { font = "JetBrainsMono Nerd Font" },
    { font = "MonaspiceAr Nerd Font" },
    { font = "MonaspiceKr Nerd Font" },
    { font = "MonaspiceNe Nerd Font" },
    { font = "MonaspiceRn Nerd Font" },
    { font = "MonaspiceXe Nerd Font" },
  },
})
require("config.keys").apply(c)
require("config.zen-mode")

c.front_end = "WebGpu"

if utils.is_darwin() then
  c.window_decorations = "RESIZE|INTEGRATED_BUTTONS"
  c.window_padding = { left = 0, right = 0, top = 50, bottom = 0 }
else
  c.window_decorations = "NONE"
  c.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
end

c.adjust_window_size_when_changing_font_size = false
c.audible_bell = "Disabled"
c.default_cursor_style = "BlinkingBar"
c.inactive_pane_hsb = { brightness = 0.90 }

require("bar.plugin").apply_to_config(c)
require("milspec.plugin").apply_to_config(c, { sync = true })

return c
