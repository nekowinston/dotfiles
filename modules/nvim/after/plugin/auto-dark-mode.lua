local present, autodm = pcall(require, "auto-dark-mode")

if not present or not (vim.fn.has("mac") == 1) then
  return
end

autodm.setup({})
autodm.init()
