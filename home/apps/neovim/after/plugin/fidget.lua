local present, fidget = pcall(require, "fidget")

if not present then
  return
end

fidget.setup({
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
})
