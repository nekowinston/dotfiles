local wezterm = require("wezterm")
local theme = require("theme")
require("bar").setup({
  dividers = "slant_right", -- or "slant_left", "arrows", "rounded", false
  indicator = {
    leader = {
      enabled = true,
      icon_off = " ",
      icon_on = " ",
    },
    mode = {
      enabled = true,
      names = {
        resize_mode = "RESIZE",
        copy_mode = "VISUAL",
        search_mode = "SEARCH",
      },
    },
  },
  tabs = {
    numerals = "arabic", -- or "roman"
    pane_count = "superscript", -- or "subscript", false
    brackets = {
      active = { "", ":" },
      inactive = { "", ":" },
    },
  },
  clock = { -- note that this overrides the whole set_right_status
    enabled = true,
    format = "%H:%M", -- use https://wezfurlong.org/wezterm/config/lua/wezterm.time/Time/format.html
  },
})

wezterm.GLOBAL = {
  font = "berkeley",
  enable_tab_bar = true,
}
local font = require("fonts").get_font(wezterm.GLOBAL.font)

local options = {
  set_environment_variables = {
    TERMINFO_DIRS = wezterm.home_dir .. "/.nix-profile/share/terminfo",
  },
  -- font
  font = font.font,
  font_size = font.size,
  -- window
  window_decorations = "RESIZE",
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  inactive_pane_hsb = {
    saturation = 1.0,
    brightness = 0.6,
  },
  -- theme
  color_schemes = theme.get_custom_colorschemes(),
  color_scheme = theme.scheme_for_appearance(wezterm.gui.get_appearance(), {
    dark = "Catppuccin Americano",
    light = "Catppuccin Latte",
  }),
  -- tab bar
  tab_bar_at_bottom = true,
  tab_max_width = 32,
  use_fancy_tab_bar = false,
  window_background_opacity = 1.00,
  hide_tab_bar_if_only_one_tab = false,
  enable_tab_bar = wezterm.GLOBAL.tab_bar_hidden,
  -- etc.
  adjust_window_size_when_changing_font_size = false,
  use_resize_increments = false,
  audible_bell = "Disabled",
  clean_exit_codes = { 130 },
  default_cursor_style = "BlinkingBar",
  enable_scroll_bar = false,
}

for k, v in pairs(require("keys")) do
  options[k] = v
end

return options
