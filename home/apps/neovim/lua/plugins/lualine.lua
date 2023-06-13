---@type LazyPluginSpec[]
return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      {
        "SmiteshP/nvim-navic",
        dependencies = { "neovim/nvim-lspconfig" },
        opts = {
          highlight = true,
          separator = " ",
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
        },
      },
    },
    config = function()
      local lualine = require("lualine")
      lualine.setup({
        options = {
          icons_enabled = true,
          theme = "catppuccin",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "searchcount" },
          lualine_x = { { "filetype", colored = false } },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        tabline = {},
        winbar = {
          lualine_c = { "navic" },
          lualine_x = {
            {
              function()
                return "  "
              end,
              cond = function()
                local present, navic = pcall(require, "nvim-navic")
                if not present then
                  return false
                end
                return navic.is_available()
              end,
            },
          },
        },
        inactive_winbar = {},
        extensions = {},
      })
    end,
  },
}
