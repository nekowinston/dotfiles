local wezterm = require("wezterm")
local M = {}

local function get_victor(weigth)
  return wezterm.font({
    family = "Victor Mono",
    style = "Italic",
    weight = weigth,
  })
end

M.apply = function(c)
  c.font = wezterm.font_with_fallback({
    "Berkeley Mono",
    "Symbols Nerd Font",
  })
  c.font_rules = {
    {
      font = get_victor("Black"),
      intensity = "Bold",
      italic = true,
    },
    {
      font = get_victor("Bold"),
      intensity = "Half",
      italic = true,
    },
    {
      font = get_victor("DemiBold"),
      intensity = "Normal",
      italic = true,
    },
  }
end

return M
