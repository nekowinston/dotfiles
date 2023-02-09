local present, treesitter = pcall(require, "nvim-treesitter.configs")
if not present then
  return
end

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.gotmpl = {
  install_info = {
    url = "https://github.com/ngalaiko/tree-sitter-go-template",
    files = { "src/parser.c" },
  },
  filetype = "gotmpl",
  used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl", "yaml", "helm" },
}

local ft_to_parser = require("nvim-treesitter.parsers").filetype_to_parsername
ft_to_parser.helm = "gotmpl"

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
