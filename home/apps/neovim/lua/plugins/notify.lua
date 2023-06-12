---@type LazyPluginSpec[]
return {
  {
    "rcarriga/nvim-notify",
    config = function()
      local notify = require("notify")
      local stages = require("notify.stages.static")("top_down")
      notify.setup({
        background_colour = "#000000",
        delay = 5000,
        stages = {
          function(...)
            local opts = stages[1](...)
            if opts then
              opts.border = vim.g.bc.style
            end
            return opts
          end,
          unpack(stages, 2),
        },
      })
      vim.notify = notify
    end,
  },
}
