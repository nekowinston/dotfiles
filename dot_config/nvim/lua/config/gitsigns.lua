require("gitsigns").setup({
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
