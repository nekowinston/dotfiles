local wezterm = require("wezterm")
local utils = require("utils")

local nonpadded_apps = { "nvim", "btop", "btm" }

wezterm.on("smartpadding", function(window, pane)
  local fgp = pane:get_foreground_process_info()
  if fgp == nil then
    return
  elseif utils.tableContains(nonpadded_apps, fgp.name) then
    window:set_config_overrides({
      window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
    })
  else
    window:set_config_overrides({
      window_padding = wezterm.GLOBAL.smart_padding,
    })
  end
end)

wezterm.on("update-status", function(window, pane)
  if wezterm.GLOBAL.smart_padding ~= nil then
    wezterm.emit("smartpadding", window, pane)
  end
end)
