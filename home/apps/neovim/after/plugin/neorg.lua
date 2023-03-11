local present, neorg = pcall(require, "neorg")

if not present then
  return
end

neorg.setup({
  load = {
    ["core.defaults"] = {},
  },
})
