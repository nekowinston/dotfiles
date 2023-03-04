local wezterm = require("wezterm")

local M = {}

-- fonts I like, with the settings I prefer
-- kept separately from the rest of the config so that I can easily change them
local fonts = {
  berkeley = {
    font = "Berkeley Mono",
    size = 16,
  },
  comic = {
    font = "Comic Code Ligatures",
    size = 16,
  },
  victor = {
    font = {
      family = "Victor Mono",
      weight = "DemiBold",
      harfbuzz_features = { "ss02=1" },
    },
    size = 15,
  },
}

M.get_font = function(name)
  return {
    font = wezterm.font_with_fallback({
      fonts[name].font,
      "Symbols Nerd Font",
    }),
    size = fonts[name].size,
  }
end

wezterm.on("switch-font", function(window, _)
  local next_font = next(fonts, wezterm.GLOBAL.font)
  if next_font == nil then
    next_font = next(fonts)
  end
  wezterm.GLOBAL.font = next_font

  window:set_config_overrides({
    font = M.get_font(next_font).font,
    font_size = M.get_font(next_font).size,
  })
end)

return M
