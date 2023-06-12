---@type LazySpec[]
return {
  {
    {
      "nvim-telescope/telescope.nvim",
      config = function()
        local telescope = require("telescope")

        pcall(telescope.load_extension, "fzf")
        pcall(telescope.load_extension, "asynctasks")
        pcall(telescope.load_extension, "file_browser")
        pcall(telescope.load_extension, "project")
        pcall(telescope.load_extension, "notify")

        telescope.setup({
          defaults = {
            selection_caret = "▶ ",
            borderchars = {
              vim.g.bc.horiz,
              vim.g.bc.vert,
              vim.g.bc.horiz,
              vim.g.bc.vert,
              vim.g.bc.topleft,
              vim.g.bc.topright,
              vim.g.bc.botright,
              vim.g.bc.botleft,
            },
          },
          extensions = {
            file_browser = {
              grouped = true,
              sorting_strategy = "ascending",
            },
            fzf = {
              fuzzy = true,
              override_generic_sorter = true,
              override_file_sorter = true,
              case_mode = "smart_case",
            },
          },
        })
      end,
      dependencies = {
        "nvim-lua/plenary.nvim",
        {
          "nvim-telescope/telescope-fzf-native.nvim",
          build = "make",
        },
        "GustavoKatel/telescope-asynctasks.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
        "nvim-telescope/telescope-project.nvim",
      },
    },

    -- octo extension
    {
      "pwntester/octo.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-tree/nvim-web-devicons",
      },
      opts = {},
    },
  },
}
