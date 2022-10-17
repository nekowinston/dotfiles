local home = os.getenv("HOME")
local db = require("dashboard")

db.custom_header = function()
  local cringe = {
    "Have fun coding!",
    "Sisyphus wasn't forbidden to smile.",
    "Pro tip: Run :q! to exit. Now!",
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

db.custom_center = {
  {
    icon = "  ",
    desc = "Open Projects                           ",
    action = "Telescope project",
  },
  {
    icon = "  ",
    desc = "Find File                               ",
    action = "Telescope find_files find_command=rg,--hidden,--files",
  },
  {
    icon = "  ",
    desc = "File Browser                            ",
    action = "Telescope file_browser",
  },
  {
    icon = "  ",
    desc = "Find word                               ",
    action = "Telescope live_grep",
  },
  {
    icon = "  ",
    desc = "Open Settings                           ",
    action = function()
      vim.cmd("cd " .. home .. "/.config/nvim/")
      vim.cmd("edit init.lua")
    end,
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
