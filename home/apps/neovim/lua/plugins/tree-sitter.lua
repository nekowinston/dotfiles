return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
    config = function()
      local treesitter = require("nvim-treesitter.configs")
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

      vim.o.foldmethod = "expr"
      vim.o.foldexpr = "nvim_treesitter#foldexpr()"
      vim.o.foldenable = false
    end,
  },
  "nvim-treesitter/playground",
  "windwp/nvim-ts-autotag",
  "HiPhish/nvim-ts-rainbow2",

  -- not treesitter, but close enough
  {
    "wuelnerdotexe/vim-astro",
    config = function()
      vim.g.astro_typescript = "enable"
    end,
  },
  "noahtheduke/vim-just",
}
