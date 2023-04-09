local wezterm = require("wezterm")

local M = {}
M.apply_to_config = function(c)
  local default_padding = c.window_padding

  wezterm.on("smart-padding", function(window, pane)
    if pane:is_alt_screen_active() then
      window:set_config_overrides({
        window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
      })
    else
      window:set_config_overrides({
        window_padding = default_padding,
      })
    end
  end)

  wezterm.on("update-status", function(window, pane)
    wezterm.emit("smart-padding", window, pane)
  end)
end
return M
