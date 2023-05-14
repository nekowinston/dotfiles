---@type LazyPluginSpec[]
return {
  {
    "nvim-pack/nvim-spectre",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      replace_engine = {
        sed = {
          cmd = "sed",
        },
      },
    },
  },
}
