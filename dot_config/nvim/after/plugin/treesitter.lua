local present, treesitter = pcall(require, "nvim-treesitter.configs")
if not present then return end

treesitter.setup({
  auto_install = true,
  ignore_install = {
    "phpdoc",
  },
  highlight = {
    enable = true,
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = 8192,
  },
  ensure_installed = {
    "bash",
    "css",
    "dockerfile",
    "go",
    "html",
    "javascript",
    "json",
    "lua",
    "markdown",
    "python",
    "regex",
    "rust",
    "scss",
    "toml",
    "tsx",
    "typescript",
    "yaml",
  },
})
