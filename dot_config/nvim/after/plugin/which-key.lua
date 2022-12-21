local wk = require("which-key")
wk.setup({
  key_labels = {
    ["<space>"] = "SPC",
    ["<leader>"] = "SPC",
    ["<cr>"] = " ",
    ["<tab>"] = " ",
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
    b = { "<cmd>Telescope file_browser<cr>", "File Browser" },
    c = { "<cmd>Easypick  chezmoi<cr>", "Chezmoi" },
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

wk.register({
  -- easier split navigation
  ["<C-J>"] = { "<C-W>j" },
  ["<C-K>"] = { "<C-W>k" },
  ["<C-L>"] = { "<C-W>l" },
  ["<C-H>"] = { "<C-W>h" },
  ["<C-W>\\"] = { "<cmd>vsplit<cr>" },
  ["<C-W>-"] = { "<cmd>split<cr>" },
  ["<C-W>x"] = { "<cmd>q<cr>" },
  -- diffs
  ["<leader>gd"] = { "<cmd>Gvdiff!<cr>", "Diff vsplit" },
  ["gd"] = { "<cmd>diffget<cr>", "Get from diff" },
  ["gdh"] = { "<cmd>diffget //2<cr>", "Get diff from the left" },
  ["gdl"] = { "<cmd>diffget //3<cr>", "Get diff from the right" },
})
