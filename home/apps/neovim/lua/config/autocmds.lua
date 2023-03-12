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
