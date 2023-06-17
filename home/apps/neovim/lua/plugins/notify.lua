---@type LazyPluginSpec[]
return {
  {
    "rcarriga/nvim-notify",
    config = function()
      local notify = require("notify")
      notify.setup({
        timeout = 1000,
        render = "compact",
        stages = "fade",
      })
      vim.notify = notify
    end,
  },
}
