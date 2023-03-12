return {
  {
    "j-hui/fidget.nvim",
    opts = {
      text = {
        spinner = "dots",
        done = "﫠",
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
