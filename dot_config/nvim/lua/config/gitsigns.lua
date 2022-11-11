require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    -- Navigation
    Map("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })

    Map("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })

    -- Actions
    Map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
    Map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
    Map("n", "<leader>hS", gs.stage_buffer)
    Map("n", "<leader>hu", gs.undo_stage_hunk)
    Map("n", "<leader>hR", gs.reset_buffer)
    Map("n", "<leader>hp", gs.preview_hunk)
    Map("n", "<leader>hb", function()
      gs.blame_line({ full = true })
    end)
    Map("n", "<leader>tb", gs.toggle_current_line_blame)
    Map("n", "<leader>hd", gs.diffthis)
    Map("n", "<leader>hD", function()
      gs.diffthis("~")
    end)
    Map("n", "<leader>td", gs.toggle_deleted)

    -- Text object
    Map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
  end,
  signs = {
    add = {
      hl = "GitSignsAdd",
      text = "+",
      numhl = "GitSignsAddNr",
      linehl = "GitSignsAddLn",
    },
    change = {
      hl = "GitSignsChange",
      text = "~",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
    delete = {
      hl = "GitSignsDelete",
      text = "_",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    topdelete = {
      hl = "GitSignsDelete",
      text = "‾",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    changedelete = {
      hl = "GitSignsChange",
      text = "x",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
  },
  linehl = false,
  numhl = false,
  signcolumn = true,
  word_diff = false,
  watch_gitdir = { enable = false, interval = 1000, follow_files = true },
  attach_to_untracked = true,
  -- current line highlighting
  current_line_blame = true,
  current_line_blame_opts = {
    delay = 1000,
    ignore_whitespace = true,
    virt_text = true,
    virt_text_pos = "eol",
  },
  current_line_blame_formatter = "<author>, <author_time:%R> - <summary> | <abbrev_sha>",
  -- perf
  max_file_length = 40000,
  sign_priority = 6,
  update_debounce = 100,
  -- use the included status formatter
  status_formatter = nil,
  preview_config = {
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  yadm = { enable = false },
})
