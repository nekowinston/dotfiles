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

local numbertoggle = vim.api.nvim_create_augroup("numbertoggle", {})
local ignore_ft = { "alpha", "TelescopePrompt", "" }

---@param callback fun(): nil
local ft_guard = function(callback)
  if not vim.tbl_contains(ignore_ft, vim.bo.filetype) then
    callback()
  end
end

vim.api.nvim_create_autocmd(
  { "InsertEnter", "BufLeave", "WinLeave", "FocusLost" },
  {
    callback = function()
      ft_guard(function()
        vim.opt_local.rnu = false
      end)
    end,
    group = numbertoggle,
  }
)
vim.api.nvim_create_autocmd(
  { "InsertLeave", "BufEnter", "WinEnter", "FocusGained" },
  {
    callback = function()
      ft_guard(function()
        vim.opt_local.rnu = true
      end)
    end,
    group = numbertoggle,
  }
)
vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdlineLeave" }, {
  callback = function(data)
    ft_guard(function()
      vim.opt.rnu = data.event == "CmdlineLeave"
      vim.cmd("redraw")
    end)
  end,
  group = numbertoggle,
})
