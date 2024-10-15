local wezterm = require("wezterm")
local io = require("io")

wezterm.GLOBAL.fonts = {
  "BerkeleyMono Nerd Font",
  "BlexMono Nerd Font",
  "CaskaydiaMonoNF Nerd Font",
  "ComicCodeLigatures Nerd Font",
  "IntoneMono Nerd Font",
  "JetBrainsMono Nerd Font",
  "MonaspiceAr Nerd Font",
  "MonaspiceKr Nerd Font",
  "MonaspiceNe Nerd Font",
  "MonaspiceRn Nerd Font",
  "MonaspiceXe Nerd Font",
}

local M = {}

M.apply = function(config)
  local last_font_fp = wezterm.home_dir .. "/.local/share/wezterm/font.json"
  local last_font_fh = io.open(last_font_fp, "r")

  if last_font_fh ~= nil then
    local last_font = wezterm.json_parse(last_font_fh:read())
    if last_font ~= nil then
      config.font = wezterm.font(last_font)
    end
  end
end

local function selector_callback(window, _, font_id, label)
  font_id = tonumber(font_id)

  wezterm.log_info(
    "You selected font: ",
    font_id,
    label,
    wezterm.GLOBAL.fonts[font_id]
  )
  local overrides = window:get_config_overrides() or {}
  local new_font = wezterm.GLOBAL.fonts[font_id]

  overrides.font = wezterm.font(new_font)
  window:set_config_overrides(overrides)

  local fh =
    io.open(wezterm.home_dir .. "/.local/share/wezterm/font.json", "w+")

  if fh ~= nil then
    fh:write(wezterm.json_encode(new_font)):close()
  end
end

wezterm.on("switch-font", function(window, pane)
  local font_choices = {}
  for id, value in ipairs(wezterm.GLOBAL.fonts) do
    local id_string = tostring(id)
    if type(value) == "userdata" then
      table.insert(font_choices, { label = value.family, id = id_string })
    else
      table.insert(font_choices, { label = value, id = id_string })
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
