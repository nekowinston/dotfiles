local ap_present, ap = pcall(require, "nvim-autopairs")
local cmp_present, cmp = pcall(require, "cmp")
if not ap_present or cmp_present then
  return
end

ap.setup()
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
