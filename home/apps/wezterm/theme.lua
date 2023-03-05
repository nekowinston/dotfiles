local wezterm = require("wezterm")

local M = {}

M.scheme_for_appearance = function(appearance, theme)
  if string.match(wezterm.target_triple, "linux") then
    return theme.dark
  end
  if appearance:find("Dark") then
    return theme.dark
  else
    return theme.light
  end
end

M.get_custom_colorschemes = function()
  local oledppuccin = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]
  oledppuccin.background = "#000000"
  oledppuccin.tab_bar.background = "#040404"
  oledppuccin.tab_bar.inactive_tab.bg_color = "#0f0f0f"
  oledppuccin.tab_bar.new_tab.bg_color = "#080808"

  return {
    ["Catppuccin Americano"] = oledppuccin,
  }
end

M.apply = function(c)
  c.color_schemes = M.get_custom_colorschemes()
  c.color_scheme = M.scheme_for_appearance(wezterm.gui.get_appearance(), {
    dark = "Catppuccin Americano",
    light = "Catppuccin Latte",
  })
end

return M
