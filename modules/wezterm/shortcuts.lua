local wezterm = require("wezterm")
local act = wezterm.action

return {
  -- use 'Backslash' to split horizontally
  {
    key = "\\",
    mods = "LEADER",
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  -- and 'Minus' to split vertically
  {
    key = "-",
    mods = "LEADER",
    action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  -- 'hjkl' to move between panes
  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
  -- -- Shift + 'hjkl' to resize panes
  {
    key = "h",
    mods = "LEADER|SHIFT",
    action = act.AdjustPaneSize({ "Left", 5 }),
  },
  {
    key = "j",
    mods = "LEADER|SHIFT",
    action = act.AdjustPaneSize({ "Down", 5 }),
  },
  {
    key = "k",
    mods = "LEADER|SHIFT",
    action = act.AdjustPaneSize({ "Up", 5 }),
  },
  {
    key = "l",
    mods = "LEADER|SHIFT",
    action = act.AdjustPaneSize({ "Right", 5 }),
  },
  -- numbers to navigate to tabs
  { key = "1", mods = "LEADER", action = act.ActivateTab(0) },
  { key = "2", mods = "LEADER", action = act.ActivateTab(1) },
  { key = "3", mods = "LEADER", action = act.ActivateTab(2) },
  { key = "4", mods = "LEADER", action = act.ActivateTab(3) },
  { key = "5", mods = "LEADER", action = act.ActivateTab(4) },
  { key = "6", mods = "LEADER", action = act.ActivateTab(5) },
  { key = "7", mods = "LEADER", action = act.ActivateTab(6) },
  { key = "8", mods = "LEADER", action = act.ActivateTab(7) },
  { key = "9", mods = "LEADER", action = act.ActivateTab(8) },
  { key = "9", mods = "LEADER", action = act.ActivateTab(9) },
  { key = "0", mods = "LEADER", action = act.ActivateTab(-1) },
  { key = "1", mods = "SUPER", action = act.ActivateTab(0) },
  { key = "2", mods = "SUPER", action = act.ActivateTab(1) },
  { key = "3", mods = "SUPER", action = act.ActivateTab(2) },
  { key = "4", mods = "SUPER", action = act.ActivateTab(3) },
  { key = "5", mods = "SUPER", action = act.ActivateTab(4) },
  { key = "6", mods = "SUPER", action = act.ActivateTab(5) },
  { key = "7", mods = "SUPER", action = act.ActivateTab(6) },
  { key = "8", mods = "SUPER", action = act.ActivateTab(7) },
  { key = "9", mods = "SUPER", action = act.ActivateTab(8) },
  { key = "9", mods = "SUPER", action = act.ActivateTab(9) },
  { key = "0", mods = "SUPER", action = act.ActivateTab(-1) },
  -- 'c' to create a new tab
  { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  -- 'x' to kill the current pane
  {
    key = "x",
    mods = "LEADER",
    action = act.CloseCurrentPane({ confirm = true }),
  },
  -- 'z' to toggle the zoom for the current pane
  { key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
  -- 'Z' to hide the tab bar (useful for screenshots)
  {
    key = "Z",
    mods = "LEADER",
    action = wezterm.action_callback(function(window)
      wezterm.GLOBAL.enable_tab_bar = not wezterm.GLOBAL.enable_tab_bar
      window:set_config_overrides({
        enable_tab_bar = wezterm.GLOBAL.enable_tab_bar,
      })
    end),
  },
  -- 'v' to visually select in the current pane
  { key = "v", mods = "LEADER", action = "ActivateCopyMode" },
  -- 'r' to rotate panes
  { key = "r", mods = "LEADER", action = act.RotatePanes("Clockwise") },
  { key = " ", mods = "LEADER", action = act.QuickSelect },
  {
    key = "o",
    mods = "LEADER",
    action = act.QuickSelectArgs({
      label = "open url",
      patterns = {
        "https?://\\S+",
      },
      action = wezterm.action_callback(function(window, pane)
        local url = window:get_selection_text_for_pane(pane)
        wezterm.open_with(url)
      end),
    }),
  },
  -- copypasta
  { key = "Enter", mods = "ALT", action = act.ToggleFullScreen },

  { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
  { key = "-", mods = "SUPER", action = act.DecreaseFontSize },
  { key = "=", mods = "CTRL", action = act.IncreaseFontSize },
  { key = "=", mods = "SUPER", action = act.IncreaseFontSize },
  { key = "0", mods = "CTRL", action = act.ResetFontSize },
  { key = "0", mods = "SUPER", action = act.ResetFontSize },

  { key = "c", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
  { key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
  { key = "v", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },
  { key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },

  {
    key = "f",
    mods = "SHIFT|CTRL",
    action = act.Search("CurrentSelectionOrEmptyString"),
  },
  {
    key = "f",
    mods = "SUPER",
    action = act.Search("CurrentSelectionOrEmptyString"),
  },

  { key = "l", mods = "SHIFT|CTRL", action = act.ShowDebugOverlay },

  {
    key = "p",
    mods = "LEADER",
    action = act.PaneSelect({ alphabet = "asdfghjkl;", mode = "Activate" }),
  },
  {
    key = "P",
    mods = "LEADER",
    action = act.PaneSelect({
      alphabet = "asdfghjkl;",
      mode = "SwapWithActive",
    }),
  },

  {
    key = "p",
    mods = "SUPER",
    action = act.PaneSelect({ alphabet = "asdfghjkl;", mode = "Activate" }),
  },
  {
    key = "P",
    mods = "SUPER",
    action = act.PaneSelect({
      alphabet = "asdfghjkl;",
      mode = "SwapWithActive",
    }),
  },
  { key = "R", mods = "LEADER", action = act.ReloadConfiguration },

  -- mostly OS defaults
  { key = "n", mods = "SHIFT|CTRL", action = act.SpawnWindow },
  { key = "n", mods = "SUPER", action = act.SpawnWindow },
  {
    key = "t",
    mods = "SHIFT|CTRL",
    action = act.SpawnTab("CurrentPaneDomain"),
  },
  { key = "t", mods = "SUPER", action = act.SpawnTab("CurrentPaneDomain") },
  {
    key = "w",
    mods = "SHIFT|CTRL",
    action = act.CloseCurrentTab({ confirm = true }),
  },
  {
    key = "w",
    mods = "SUPER",
    action = act.CloseCurrentTab({ confirm = true }),
  },
  {
    key = "u",
    mods = "SHIFT|CTRL",
    action = act.CharSelect({
      copy_on_select = true,
      copy_to = "ClipboardAndPrimarySelection",
    }),
  },
}
