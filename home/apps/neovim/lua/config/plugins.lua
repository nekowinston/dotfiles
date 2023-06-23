local M = {}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

M.setup = function(plugins)
  require("lazy").setup(plugins, {
    install = { colorscheme = { "catppuccin" } },
    ui = { border = vim.g.bc.style },
  })
end

return M
