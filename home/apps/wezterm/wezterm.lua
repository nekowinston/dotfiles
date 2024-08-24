local wezterm = require("wezterm")
local c = wezterm.config_builder()

require("config.keys").apply(c)

c.font = wezterm.font_with_fallback({
  "Berkeley Mono",
  -- "Cascadia Code",
  -- "IBM Plex Mono",
  -- "Comic Code Ligatures",
  "Symbols Nerd Font",
})
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

-- folke/zen-mode.nvim
wezterm.on("user-var-changed", function(window, pane, name, value)
  local overrides = window:get_config_overrides() or {}
  if name == "ZEN_MODE" then
    local incremental = value:find("+")
    local number_value = tonumber(value)
    if incremental ~= nil then
      while number_value > 0 do
        window:perform_action(wezterm.action.IncreaseFontSize, pane)
        number_value = number_value - 1
      end
      overrides.enable_tab_bar = false
    elseif number_value < 0 then
      window:perform_action(wezterm.action.ResetFontSize, pane)
      overrides.font_size = nil
      overrides.enable_tab_bar = true
    else
      overrides.font_size = number_value
      overrides.enable_tab_bar = false
    end
  end
  window:set_config_overrides(overrides)
end)

return c
