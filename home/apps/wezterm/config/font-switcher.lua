local wezterm = require("wezterm")
local io = require("io")

---@class FontTable
---@field family string
---@field weight? string
---@field harfbuzz_features? string[]

---@alias Font FontTable | string

---@class FontOption
---@field font Font
---@field size? number
---@field command_palette_font Font

local M = {}

---@class Defaults
---@field size? number
---@field command_palette_font? Font

---@type Defaults
local defaults = {
  size = 13,
  command_palette_font = "IBM Plex Sans",
}

---@param config table<string, any>
---@param option FontOption
---@return table<string, any>
local function apply_font_option(config, option)
  config.font = wezterm.font(option.font)
  config.font_size = option.size or defaults.size
  config.command_palette_font_size = (option.size or defaults.size) * 1.1

  local window_frame = config.window_frame or {}
  window_frame.font =
    wezterm.font(option.command_palette_font or defaults.command_palette_font)
  config.window_frame = window_frame

  return config
end

---@param config any
---@param options {fonts: table<string, FontOption>}
M.apply = function(config, options)
  wezterm.GLOBAL.fonts = options.fonts

  local last_font_fp = wezterm.home_dir .. "/.local/share/wezterm/font.json"
  local last_font_fh = io.open(last_font_fp, "r")

  if last_font_fh ~= nil then
    local last_font = wezterm.json_parse(last_font_fh:read())
    if last_font ~= nil then
      apply_font_option(config, last_font)
    end
  end
end

local function selector_callback(window, _, font_id, _)
  ---@type FontOption
  local new_font = wezterm.GLOBAL.fonts[tonumber(font_id)]

  local overrides =
    apply_font_option(window:get_config_overrides() or {}, new_font)
  window:set_config_overrides(overrides)

  local fh =
    io.open(wezterm.home_dir .. "/.local/share/wezterm/font.json", "w+")

  if fh ~= nil then
    fh:write(wezterm.json_encode(new_font)):close()
  end
end

wezterm.on("switch-font", function(window, pane)
  local font_choices = {}
  ---@param id string
  ---@param value FontOption
  for id, value in ipairs(wezterm.GLOBAL.fonts) do
    local id_string = tostring(id)
    if type(value.font) == "userdata" then
      table.insert(font_choices, { label = value.font.family, id = id_string })
    else
      table.insert(font_choices, { label = value.font, id = id_string })
    end
  end

  window:perform_action(
    wezterm.action.InputSelector({
      action = wezterm.action_callback(selector_callback),
      title = "Switch Font",
      choices = font_choices,
    }),
    pane
  )
end)

return M
