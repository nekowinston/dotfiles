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
            border = "double",
          },
        },
      },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
}
