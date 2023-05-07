return {
  {
    "folke/which-key.nvim",
    config = function()
      local wk = require("which-key")

      wk.setup({
        key_labels = {
          ["<space>"] = "␣",
          ["<leader>"] = "␣",
          ["<cr>"] = "󰌑 ",
          ["<tab>"] = "󰌒 ",
          ["<esc>"] = "⎋ ",
        },
        window = {
          border = "double",
          margin = { 0, 0, 0, 0 },
        },
      })

      -- Telescope
      wk.register({
        ["<leader>f"] = {
          name = "+Telescope",
          b = { "<cmd>Telescope buffers<cr>", "File Browser" },
          d = { "<cmd>Telescope find_files<cr>", "Find File" },
          g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
          h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
          p = { "<cmd>Telescope project<cr>", "Project" },
          r = { "<cmd>Telescope asynctasks all<cr>", "Run Asynctasks" },
          s = {
            function()
              local confpath = vim.fn.resolve(vim.fn.stdpath("config"))
              require("telescope.builtin").find_files({ cwd = confpath })
            end,
            "Find in config",
          },
        },
      })

      -- clipboard
      wk.register({
        ["<leader>"] = {
          y = { '"+y', "Copy to clipboard" },
          p = { '"+p', "Paste from clipboard" },
          db = { "<cmd>DBUIToggle<cr>", "Toggle DBUI" },
          gd = { "<cmd>Gvdiff!<CR>", "Git Diff" },
          ng = { "<cmd>Neogit<cr>", "Neogit" },
          sl = { "<cmd>SessionLoad<cr>", "Load Session" },
        },
      }, { mode = { "n", "v" } })
    end,
  },
}
