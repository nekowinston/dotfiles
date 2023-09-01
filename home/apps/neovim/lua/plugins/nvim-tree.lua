---@type LazyPluginSpec[]
return {
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      renderer = {
        indent_markers = {
          enable = true,
        },
      },
      diagnostics = {
        enable = true,
      },
      actions = {
        file_popup = {
          open_win_config = {
            border = vim.g.bc.style,
          },
        },
      },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      local C = require("catppuccin.palettes").get_palette()

      local devicons = require("nvim-web-devicons")
      local justfile = {
        icon = "󱚣",
        name = "Justfile",
        color = C.peach,
      }
      devicons.setup({
        override_by_extension = {
          ["astro"] = {
            icon = "",
            name = "Astro",
            color = C.red,
          },
          ["norg"] = {
            icon = "",
            name = "Neorg",
            color = C.green,
          },
        },
        override_by_filename = {
          [".ecrc"] = {
            icon = "",
            name = "EditorConfigChecker",
            color = C.green,
          },
          [".envrc"] = {
            icon = "",
            name = "envrc",
            color = C.yellow,
          },
          [".editorconfig"] = {
            icon = "",
            name = "EditorConfig",
            color = C.green,
          },
          [".luacheckrc"] = {
            icon = "󰢱",
            name = "LuacheckRC",
            color = C.blue,
          },
          [".Justfile"] = justfile,
          [".justfile"] = justfile,
          ["Justfile"] = justfile,
          ["justfile"] = justfile,
        },
      })
    end,
  },
}
