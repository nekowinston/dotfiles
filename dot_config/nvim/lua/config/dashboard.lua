local db = require("dashboard")

db.custom_header = function()
  local cringe = {
    "Have fun coding!",
    "neovim got rid of the :smile command.",
    "Pro tip: You can use :q to exit. Do it. Now!",
  }
  local random_cringe = cringe[math.random(#cringe)]
  return {
    [[╭──────────────────────────────────────────────────╮]],
    [[│⠀⠀⠀⠀⠀⠀⡏⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣄⢧⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀│]],
    [[│⠀⠀⠀⠀⠀⢰⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠘⣄⠀⠀⠀⠀⢹⣦⠀⠀⠀⠀⠀⠀⠀⠀│]],
    [[│⠀⠀⠀⠀⠀⠘⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡄⠀⠀⠀⠈⠙⣧⡀⠀⠀⠀⠀⠀⠀│]],
    [[│⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⠀⠀⠀⠀⢸⡼⣇⠀⠀⠀⠀⠀⠀│]],
    [[│⠀⠀⠀⠀⠀⠀⢿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠖⠀⠀⡸⠀⠀⠀⡟⠈⠃⣿⠀⠀⠀⠀⠀⠀│]],
    [[│⠀⠀⠀⠀⠀⠀⢺⡇⠀⠀⠀⠀⠀⠀⣀⣶⣶⠀⠀⠀⠀⠀⣠⣶⣶⣶⣶⣦⣤⣀⣀⣤⡶⠶⠶⠶⡇⠀⠀⣼⣿⣶⠀⣿⠀⠀⠀⠀⠀⠀│]],
    [[│⠀⠀⠀⠀⠀⠀⠈⣷⠀⠀⠀⣠⣾⣿⣿⣿⣿⢿⠀⠀⠀⠘⢻⠙⠛⠒⠛⠛⢉⣩⠁⠀⠀⢀⡄⠀⡇⠀⢀⣿⡿⠛⠀⣿⠀⠀⠀⠀⠀⠀│]],
    [[│⠀⠀⠀⠀⠀⠀⠀⠘⣆⠀⠈⠉⠁⣉⣉⣃⠞⣠⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠉⠁⠀⠀⠀⡾⠀⡀⠁⠀⠈⣿⠁⠀⣸⠇⠀⠀⠀⠀⠀⠀│]],
    [[│⠀⠀⠀⠀⠀⠀⠀⠀⠹⣷⠐⠀⠀⠀⠀⠀⠀⠃⠀⠀⠀⠀⠀⠀⢤⣀⡀⠀⠀⠀⠀⠀⠀⠀⣦⢱⠀⠀⠀⢿⣀⣠⠏⠀⠀⠀⠀⠀⠀⠀│]],
    [[│⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⠀⠀⠀⠀⠀⣰⡾⠃⠀⠀⠀⠀⠀⣀⣠⡿⠀⠀⣤⣄⡀⠀⠀⠀⠸⣄⠀⠀⠀⢳⡝⢯⡀⠀⠀⠀⠀⠀⠀⠀│]],
    [[│⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡀⠀⠀⠀⣰⡟⠑⠦⠴⣤⣤⣤⣾⡛⠁⠀⠀⠀⠀⠈⢷⠀⠀⠀⠀⢿⡄⠀⠀⠀⣿⡆⠙⣆⠀⠀⠀⠀⠀⠀│]],
    [[│⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⣿⠀⠀⢠⣤⣤⣄⢉⣨⣥⣶⠶⢶⣾⠶⠂⠘⠦⢤⣤⣠⡾⠃⠀⠀⠀⣿⠀⠀⠘⣦⠀⠀⠀⠀⠀│]],
    [[│⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣇⠀⣀⠀⠈⠀⠐⢿⣏⠉⠉⠉⢉⣁⣠⡶⠟⠁⠀⠀⠀⠀⠀⠈⠁⠀⠀⠀⣠⣾⡟⠀⠀⠀⠘⢧⣀⡀⠀⠀│]],
    [[│⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡄⠈⠀⠂⠀⠀⠀⠈⠉⢉⣉⣩⡭⠓⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⡿⠀⠀⠀⠀⠀⠀⠉⠉⠑⠒│]],
    [[│⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠱⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│]],
    [[│⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣨⠟⠀⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣾⣿⣿⣿⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│]],
    [[│⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡴⠋⠀⠀⡠⠇⢠⣀⠀⠀⠀⠀⠀⠀⠠⠐⠂⠀⠀⢀⣠⣼⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│]],
    [[│⠀⠀⠀⣀⣀⡠⠤⠶⠛⠁⠀⠀⠀⠈⠀⠀⠀⠛⢷⣤⣀⣀⠀⠀⠀⠀⢀⣠⣴⣿⣿⣿⣿⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│]],
    [[│⣤⠞⠋⠉⠀⡀⠀⠀⣀⡀⠀⠀⠀⠀⠀⠀⣤⣄⠘⣿⣿⣟⠛⠿⣷⣿⣿⣿⣿⣿⣿⣿⣿⣯⣿⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│]],
    [[╰──────────────────────────────────────────────────╯]],
    random_cringe,
  }
end

local padding = 25
local function pad(string)
  local str = string
  for _ = 1, padding - #string do
    str = str .. " "
  end
  return str
end

db.custom_center = {
  {
    icon = "  ",
    desc = pad("Open Projects"),
    action = "Telescope project",
    shortcut = "SPC f p",
  },
  {
    icon = "  ",
    desc = pad("Find File"),
    action = "Telescope find_files find_command=rg,--hidden,--files",
    shortcut = "SPC f f",
  },
  {
    icon = "  ",
    desc = pad("File Browser"),
    action = "Telescope file_browser",
    shortcut = "SPC f b",
  },
  {
    icon = "  ",
    desc = pad("Find word"),
    action = "Telescope live_grep",
    shortcut = "SPC f g",
  },
  {
    icon = "  ",
    desc = pad("Open Settings"),
    action = function()
      local confpath = vim.fn.resolve(vim.fn.stdpath("config"))
      require("telescope.builtin").find_files({ cwd = confpath })
    end,
    shortcut = "SPC f s",
  },
}

db.custom_footer = function()
  local v = vim.version()
  local vStr = string.format("%d.%d.%d", v.major, v.minor, v.patch)
  local plugCount = #vim.tbl_keys(packer_plugins)
  return {
    "masochism " .. vStr,
    plugCount .. " regrets",
  }
end
