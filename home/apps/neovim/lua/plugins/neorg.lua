---@type LazyPluginSpec[]
return {
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    opts = {
      load = {
        ["core.defaults"] = {},
      },
    },
  },
}
