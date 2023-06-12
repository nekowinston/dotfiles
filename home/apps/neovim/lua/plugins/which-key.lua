---@type LazyPluginSpec[]
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
          border = vim.g.bc.style,
          margin = { 0, 0, 0, 0 },
        },
      })

      -- Telescope
      wk.register({
        ["<leader>f"] = {
          name = "+Telescope",
          b = { "<cmd>Telescope file_browser grouped=true<cr>", "File browser" },
          d = { "<cmd>Telescope find_files<cr>", "Find file" },
          g = { "<cmd>Telescope live_grep<cr>", "Live grep" },
          h = { "<cmd>Telescope help_tags<cr>", "Help tags" },
          n = { "<cmd>Telescope notify<cr>", "Show notifications" },
          p = { "<cmd>Telescope project<cr>", "Project" },
          r = { "<cmd>Telescope asynctasks all<cr>", "Run asynctasks" },
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
          gd = { "<cmd>Gvdiff!<CR>", "Git diff" },
          ng = { "<cmd>Neogit<cr>", "Neogit" },
        },
      }, { mode = { "n", "v" } })
    end,
  },
}
