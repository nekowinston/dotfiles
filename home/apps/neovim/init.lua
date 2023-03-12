if vim.g.vscode then
  pcall(require, "config.vscode")
else
  require("config")
end
