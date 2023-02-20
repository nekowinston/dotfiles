local present, nvimtree = pcall(require, "nvim-tree")

if not present then
  return
end

nvimtree.setup({
  renderer = {
    indent_markers = {
      enable = true,
    },
  },
  diagnostics = {
    enable = true,
  },
  actions = {
    file_popup = {
      open_win_config = {
        border = "double",
      },
    },
  },
})
