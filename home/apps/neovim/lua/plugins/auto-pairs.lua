return {
  {
    "windwp/nvim-autopairs",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    config = function()
      local ap = require("nvim-autopairs")
      local cmp = require("cmp")
      ap.setup()
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
}
