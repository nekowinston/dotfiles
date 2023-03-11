local present, lualine = pcall(require, "lualine")

if not present then
  return
end

local navic_present, navic = pcall(require, "nvim-navic")

if navic_present then
  navic.setup({
    icons = {
      File = " ",
      Module = " ",
      Namespace = " ",
      Package = " ",
      Class = " ",
      Method = " ",
      Property = " ",
      Field = " ",
      Constructor = " ",
      Enum = " ",
      Interface = " ",
      Function = " ",
      Variable = " ",
      Constant = " ",
      String = " ",
      Number = " ",
      Boolean = " ",
      Array = " ",
      Object = " ",
      Key = " ",
      Null = " ",
      EnumMember = " ",
      Struct = " ",
      Event = " ",
      Operator = " ",
      TypeParameter = " ",
    },
  })
end

local function navic_available()
  return navic_present and navic.is_available()
end

local function navic_get_location()
  if not navic_available() then
    return ""
  end
  return navic.get_location()
end

local config = {
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    },
  },
  sections = {
    lualine_a = {
      {
        "mode",
        fmt = function(str)
          return " " .. str
        end,
      },
    },
    lualine_b = {
      { "branch", icon = "" },
      "diff",
      "diagnostics",
    },
    lualine_c = {
      { navic_get_location, condition = navic_available },
      "searchcount",
      "lsp_progress",
    },
    lualine_x = { "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
}

lualine.setup(config)
