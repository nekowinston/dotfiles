local wezterm = require("wezterm")
local utils = require("utils")

local M = {}

local defaults = {
  size = 16,
  ui_font = "IBM Plex Sans",
}

-- fonts I like, with the settings I prefer
-- kept separately from the rest of the config so that I can easily change them
local fonts = {
  berkeley = { font = "Berkeley Mono" },
  comic = {
    font = "Comic Code Ligatures",
    ui_font = "xkcd Script",
  },
  victor = {
    font = {
      family = "Victor Mono",
      weight = "DemiBold",
      harfbuzz_features = { "ss02=1" },
    },
    size = defaults.size - 1,
  },
}

for k, v in pairs(fonts) do
  fonts[k] = utils.tableMerge(v, defaults)
end

M.get_font = function(name)
  return {
    font = wezterm.font_with_fallback({
      fonts[name].font,
      "Symbols Nerd Font",
    }),
    size = fonts[name].size,
    ui_font = wezterm.font(fonts[name].ui_font),
  }
end

wezterm.on("switch-font", function(window, _)
  local next_font = next(fonts, wezterm.GLOBAL.font)
  if next_font == nil then
    next_font = next(fonts)
  end
  wezterm.GLOBAL.font = next_font

  local f = M.get_font(next_font)
  local window_frame = window:effective_config().window_frame
  window_frame = utils.tableMerge({ font = f.ui_font }, window_frame)
  window:set_config_overrides({
    font = f.font,
    font_size = f.size,
    window_frame = window_frame,
  })
end)

wezterm.GLOBAL = { font = "berkeley" }
M.apply = function(c)
  local f = M.get_font(wezterm.GLOBAL.font)
  c.font = f.font
  c.font_size = f.size
  if c.window_frame == nil then
    c.window_frame = {}
  end
  c.window_frame.font = f.ui_font
end

return M
