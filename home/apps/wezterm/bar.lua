local wezterm = require("wezterm")

local DIVIDERS = {
  LEFT = utf8.char(0xe0be),
  RIGHT = utf8.char(0xe0bc),
}

-- superscript/subscript
local function numberStyle(number, script)
  local scripts = {
    superscript = {
      "⁰",
      "¹",
      "²",
      "³",
      "⁴",
      "⁵",
      "⁶",
      "⁷",
      "⁸",
      "⁹",
    },
    subscript = {
      "₀",
      "₁",
      "₂",
      "₃",
      "₄",
      "₅",
      "₆",
      "₇",
      "₈",
      "₉",
    },
  }
  local numbers = scripts[script]
  local number_string = tostring(number)
  local result = ""
  for i = 1, #number_string do
    local char = number_string:sub(i, i)
    local num = tonumber(char)
    if num then
      result = result .. numbers[num + 1]
    else
      result = result .. char
    end
  end
  return result
end

-- custom tab bar
wezterm.on(
  "format-tab-title",
  function(tab, tabs, panes, config, hover, max_width)
    local colours = config.resolved_palette.tab_bar

    local active_tab_index = 0
    for _, t in ipairs(tabs) do
      if t.is_active == true then
        active_tab_index = t.tab_index
      end
    end

    local rainbow = {
      config.resolved_palette.ansi[2],
      config.resolved_palette.indexed[16],
      config.resolved_palette.ansi[4],
      config.resolved_palette.ansi[3],
      config.resolved_palette.ansi[5],
      config.resolved_palette.ansi[6],
    }

    local i = tab.tab_index % 6
    local active_bg = rainbow[i + 1]
    local active_fg = colours.background
    local inactive_bg = colours.inactive_tab.bg_color
    local inactive_fg = colours.inactive_tab.fg_color
    local new_tab_bg = colours.new_tab.bg_color

    local s_bg, s_fg, e_bg, e_fg

    -- the last tab
    if tab.tab_index == #tabs - 1 then
      if tab.is_active then
        s_bg = active_bg
        s_fg = active_fg
        e_bg = new_tab_bg
        e_fg = active_bg
      else
        s_bg = inactive_bg
        s_fg = inactive_fg
        e_bg = new_tab_bg
        e_fg = inactive_bg
      end
    elseif tab.tab_index == active_tab_index - 1 then
      s_bg = inactive_bg
      s_fg = inactive_fg
      e_bg = rainbow[(i + 1) % 6 + 1]
      e_fg = inactive_bg
    elseif tab.is_active then
      s_bg = active_bg
      s_fg = active_fg
      e_bg = inactive_bg
      e_fg = active_bg
    else
      s_bg = inactive_bg
      s_fg = inactive_fg
      e_bg = inactive_bg
      e_fg = inactive_bg
    end

    local tabi = wezterm.mux.get_tab(tab.tab_id)
    local muxpanes = tabi:panes()
    local count = #muxpanes == 1 and "" or tostring(#muxpanes)
    local index = tab.tab_index + 1 .. ": "

    -- start and end hardcoded numbers are the Powerline + " " padding
    local fillerwidth = 2 + string.len(index) + string.len(count) + 2

    local tabtitle = tab.active_pane.title
    if (#tabtitle + fillerwidth) > config.tab_max_width then
      tabtitle = string.sub(
        tab.active_pane.title,
        1,
        (config.tab_max_width - fillerwidth - 1)
      ) .. "…"
    end

    local title = string.format(
      " %s%s%s ",
      index,
      tabtitle,
      numberStyle(count, "superscript")
    )

    return {
      { Background = { Color = s_bg } },
      { Foreground = { Color = s_fg } },
      { Text = title },
      { Background = { Color = e_bg } },
      { Foreground = { Color = e_fg } },
      { Text = DIVIDERS.RIGHT },
    }
  end
)

local function arrContains(arr, val)
  for _, v in ipairs(arr) do
    if v == val then
      return true
    end
  end

  return false
end

local nonpadded_apps = { "nvim", "btop", "btm" }

wezterm.on("smartpadding", function(window, pane)
  local fgp = pane:get_foreground_process_info()
  if fgp == nil then
    return
  elseif arrContains(nonpadded_apps, fgp.name) then
    window:set_config_overrides({
      window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
    })
  else
    window:set_config_overrides({
      window_padding = wezterm.GLOBAL.smart_padding,
    })
  end
end)

-- custom status
wezterm.on("update-status", function(window, pane)
  if wezterm.GLOBAL.smart_padding ~= nil then
    wezterm.emit("smartpadding", window, pane)
  end

  local palette = window:effective_config().resolved_palette
  local first_tab_active = window:mux_window():tabs_with_info()[1].is_active

  local leader_text = "   "
  if window:leader_is_active() then
    leader_text = "   "
  end

  local mode_text = ""
  local mode = window:active_key_table()
  local modes = {
    resize_mode = "RESIZE",
  }
  if modes[mode] ~= nil then
    mode_text = modes[mode]
  end

  local divider_bg = first_tab_active and palette.ansi[2]
    or palette.tab_bar.inactive_tab.bg_color

  window:set_left_status(wezterm.format({
    { Foreground = { Color = palette.background } },
    { Background = { Color = palette.ansi[5] } },
    { Text = leader_text },
    { Attribute = { Intensity = "Bold" } },
    { Text = mode_text },
    "ResetAttributes",
    { Background = { Color = divider_bg } },
    { Foreground = { Color = palette.ansi[5] } },
    { Text = DIVIDERS.RIGHT },
  }))

  local time = wezterm.time.now():format("%H:%M")
  local sun_is_up = wezterm.time.now():sun_times(48.2, 16.366667).up
  local icon = sun_is_up and " " or " "
  local text = string.format("%s %s", icon, time)

  window:set_right_status(wezterm.format({
    { Background = { Color = palette.tab_bar.background } },
    { Foreground = { Color = palette.ansi[6] } },
    { Text = text },
  }))
end)
