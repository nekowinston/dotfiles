---@type LazyPluginSpec[]
return {
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    enabled = false,
    opts = {
      load = {
        ["core.defaults"] = {},
      },
    },
  },
}
