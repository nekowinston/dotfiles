local wezterm = require("wezterm")
local act = wezterm.action

local shortcuts = {}

local map = function(key, mods, action)
  if type(mods) == "string" then
    table.insert(shortcuts, { key = key, mods = mods, action = action })
  elseif type(mods) == "table" then
    for _, mod in pairs(mods) do
      table.insert(shortcuts, { key = key, mods = mod, action = action })
    end
  end
end

local toggleTabBar = wezterm.action_callback(function(window)
  wezterm.GLOBAL.enable_tab_bar = not wezterm.GLOBAL.enable_tab_bar
  window:set_config_overrides({
    enable_tab_bar = wezterm.GLOBAL.enable_tab_bar,
  })
end)

local openUrl = act.QuickSelectArgs({
  label = "open url",
  patterns = { "https?://\\S+" },
  action = wezterm.action_callback(function(window, pane)
    local url = window:get_selection_text_for_pane(pane)
    wezterm.open_with(url)
  end),
})

-- use 'Backslash' to split horizontally
map("\\", "LEADER", act.SplitHorizontal({ domain = "CurrentPaneDomain" }))
-- and 'Minus' to split vertically
map("-", "LEADER", act.SplitVertical({ domain = "CurrentPaneDomain" }))
-- map 1-9 to switch to tab 1-9, 0 for the last tab
for i = 1, 9 do
  map(tostring(i), { "LEADER", "SUPER" }, act.ActivateTab(i - 1))
end
map("0", { "LEADER", "SUPER" }, act.ActivateTab(-1))
-- 'hjkl' to move between panes
map("h", { "LEADER", "SUPER" }, act.ActivatePaneDirection("Left"))
map("j", { "LEADER", "SUPER" }, act.ActivatePaneDirection("Down"))
map("k", { "LEADER", "SUPER" }, act.ActivatePaneDirection("Up"))
map("l", { "LEADER", "SUPER" }, act.ActivatePaneDirection("Right"))
-- resize
map("h", "LEADER|SHIFT", act.AdjustPaneSize({ "Left", 5 }))
map("j", "LEADER|SHIFT", act.AdjustPaneSize({ "Down", 5 }))
map("k", "LEADER|SHIFT", act.AdjustPaneSize({ "Up", 5 }))
map("l", "LEADER|SHIFT", act.AdjustPaneSize({ "Right", 5 }))
-- spawn & close
map("c", "LEADER", act.SpawnTab("CurrentPaneDomain"))
map("x", "LEADER", act.CloseCurrentPane({ confirm = true }))
map("t", "SHIFT|CTRL", act.SpawnTab("CurrentPaneDomain"))
map("t", "SUPER", act.SpawnTab("CurrentPaneDomain"))
map("w", "SHIFT|CTRL", act.CloseCurrentTab({ confirm = true }))
map("w", "SUPER", act.CloseCurrentTab({ confirm = true }))
-- zoom states
map("z", { "LEADER", "SUPER" }, act.TogglePaneZoomState)
map("Z", { "LEADER", "SUPER" }, toggleTabBar)
-- copy & paste
map("v", "LEADER", act.ActivateCopyMode)
map("c", { "SHIFT|CTRL", "SUPER" }, act.CopyTo("Clipboard"))
map("v", { "SHIFT|CTRL", "SUPER" }, act.PasteFrom("Clipboard"))
map("f", { "SHIFT|CTRL", "SUPER" }, act.Search("CurrentSelectionOrEmptyString"))
-- rotation
map("r", { "LEADER", "SUPER" }, act.RotatePanes("Clockwise"))
-- pickers
map(" ", "LEADER", act.QuickSelect)
map("o", { "LEADER", "SUPER" }, openUrl)
map("p", { "LEADER", "SUPER" }, act.PaneSelect({ alphabet = "asdfghjkl;" }))
map("R", { "LEADER", "SUPER" }, act.ReloadConfiguration)
map("u", "SHIFT|CTRL", act.CharSelect)
-- view
map("Enter", "ALT", act.ToggleFullScreen)
map("-", { "CTRL", "SUPER" }, act.DecreaseFontSize)
map("=", { "CTRL", "SUPER" }, act.IncreaseFontSize)
map("0", { "CTRL", "SUPER" }, act.ResetFontSize)
-- OS defaults
map("n", "SHIFT|CTRL", act.SpawnWindow)
map("n", "SUPER", act.SpawnWindow)
-- debug
map("l", "SHIFT|CTRL", act.ShowDebugOverlay)

return {
  leader = { key = "s", mods = "CTRL", timeout_milliseconds = 5000 },
  keys = shortcuts,
  disable_default_key_bindings = true,
}
