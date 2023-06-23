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
      local devicons = require("nvim-web-devicons")
      local justfile = {
        icon = "󱚣",
        name = "Justfile",
        color = "#dea584",
      }
      devicons.setup({
        override_by_extension = {
          ["norg"] = {
            icon = "",
            name = "Neorg",
            color = "#77aa99",
          },
        },
        override_by_filename = {
          [".ecrc"] = {
            icon = "",
            name = "EditorConfigChecker",
            color = "#a6e3a1",
          },
          [".envrc"] = {
            icon = "",
            name = "envrc",
            color = "#faf743",
          },
          [".editorconfig"] = {
            icon = "",
            name = "EditorConfig",
            color = "#a6e3a1",
          },
          [".luacheckrc"] = {
            icon = "󰢱",
            name = "LuacheckRC",
            color = "#51a0cf",
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
