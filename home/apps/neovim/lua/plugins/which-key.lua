---@type LazyPluginSpec[]
return {
  {
    "folke/which-key.nvim",
    config = function()
      local wk = require("which-key")

      wk.setup({
        key_labels = {
          ["<space>"] = "󱁐 ",
          ["<leader>"] = "󱁐 ",
          ["<bs>"] = "󰌍 ",
          ["<cr>"] = "󰌑 ",
          ["<esc>"] = "󱊷 ",
          ["<tab>"] = "󰌒 ",
        },
        window = {
          border = vim.g.bc.style,
          margin = { 0, 0, 0, 0 },
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
