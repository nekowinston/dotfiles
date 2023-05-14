---@diagnostic disable: undefined-global

files["home/apps/neovim"] = {
  globals = { "vim" },
  std = "lua51+luajit",
}

return {
  exclude_files = {
    ".direnv/*",
    "result/*",
  },
  max_line_length = false,
}
