local wezterm = require("wezterm")

local M = {}

M.get_font = function(name)
  -- fonts I like, with the settings I prefer
  -- kept seperately from the rest of the config so that I can easily change them
  local fonts = {
    berkeley = {
      font = {
        family = "Berkeley Mono",
        weight = "Bold",
      },
      size = 16,
    },
    comic = {
      font = "Comic Code Ligatures",
      size = 18,
    },
    fantasque = {
      font = "Fantasque Sans Mono",
      size = 20,
    },
    victor = {
      font = {
        family = "Victor Mono",
        weight = "DemiBold",
        harfbuzz_features = { "ss02=1" },
      },
      size = 18,
    },
  }

  return {
    font = wezterm.font(fonts[name].font),
    size = fonts[name].size,
  }
end

return M
