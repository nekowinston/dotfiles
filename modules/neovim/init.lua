pcall(require, "impatient")

vim.g.mapleader = " "
-- netrw is handled by nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- true colors
vim.o.termguicolors = true
vim.o.cmdheight = 0
-- line numbers
vim.o.mouse = "nv"
vim.o.number = true
vim.o.relativenumber = true
-- scroll offsets
vim.o.scrolloff = 5
vim.o.sidescrolloff = 15
-- always show status & tab line
vim.o.laststatus = 3
vim.o.showtabline = 2
vim.g.termguicolors = false
-- completion height
vim.o.pumheight = 15
-- split directions
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.wrap = false
-- redefine word boundaries - '_' is a word separator, this helps with snake_case
vim.opt.iskeyword:remove("_")
-- indentations settings
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 0
vim.o.expandtab = true
vim.o.signcolumn = "yes:1"
-- double box drawing characters for splits
vim.opt.fillchars:append({
  horiz = "═",
  horizup = "╩",
  horizdown = "╦",
  vert = "║",
  vertright = "╠",
  vertleft = "╣",
  verthoriz = "╬",
})

pcall(require, "plugins")
pcall(require, "binds")

vim.api.nvim_create_autocmd("VimResized", {
  pattern = "*",
  command = "wincmd =",
  desc = "Automatically resize windows when the host window size changes.",
})

vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
  desc = "Highlight yanked text",
})

local trnuGroup = vim.api.nvim_create_augroup("toggleRnu", {})
vim.api.nvim_create_autocmd("InsertEnter,BufLeave,WinLeave,FocusLost", {
  callback = function()
    vim.opt_local.relativenumber = false
  end,
  group = trnuGroup,
})
vim.api.nvim_create_autocmd("InsertLeave,BufEnter,WinEnter,FocusGained", {
  callback = function()
    vim.opt_local.relativenumber = true
  end,
  group = trnuGroup,
})
