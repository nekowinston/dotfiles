---@type LazyPluginSpec[]
return {
  {
    "j-hui/fidget.nvim",
    branch = "legacy",
    opts = {
      text = {
        spinner = "dots",
        done = "󰗡",
        commenced = "init",
        completed = "done",
      },
      window = { blend = 0 },
      sources = {
        ["copilot"] = { ignore = true },
        ["null-ls"] = { ignore = true },
      },
    },
  },
}
