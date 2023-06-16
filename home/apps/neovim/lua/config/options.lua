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
-- always show status
vim.o.laststatus = 3
-- hide tab line
vim.o.showtabline = 0
vim.g.termguicolors = false
-- completion height
vim.o.pumheight = 15
-- split directions
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.wrap = false
vim.o.ignorecase = true
vim.o.smartcase = true
-- redefine word boundaries - '_' is a word separator, this helps with snake_case
vim.opt.iskeyword:remove("_")
-- indentations settings
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 0
vim.o.expandtab = true
-- always show 1 column of sign column (gitsigns, etc.)
vim.o.signcolumn = "yes:1"
-- hide search notices, intro
vim.opt.shortmess:append("sI")

-- stylua: ignore
local borderchars = {
  single  = {
    style = "single",
    vert = "│", vertleft = "┤", vertright = "├", horiz = "─", horizup = "┴", horizdown = "┬", verthoriz = "┼", topleft = "┌", topright = "┐", botleft = "└", botright = "┘"
  },
  double  = {
    style = "double",
    vert = "║", vertleft = "╣", vertright = "╠", horiz = "═", horizup = "╩", horizdown = "╦", verthoriz = "╬", topleft = "╔", topright = "╗", botleft = "╚", botright = "╝"
  },
  rounded = {
    style = "rounded",
    vert = "│", vertleft = "┤", vertright = "├", horiz = "─", horizup = "┴", horizdown = "┬", verthoriz = "┼", topleft = "╭", topright = "╮", botleft = "╰", botright = "╯"
  },
}

-- my custom borderchars
vim.g.bc = borderchars.rounded

-- stylua: ignore
vim.opt.fillchars:append({ horiz = vim.g.bc.horiz, horizup = vim.g.bc.horizup, horizdown = vim.g.bc.horizdown, vert = vim.g.bc.vert, vertright = vim.g.bc.vertright, vertleft = vim.g.bc.vertleft, verthoriz = vim.g.bc.verthoriz })

if vim.g.neovide then
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_refresh_rate_idle = 5
  vim.g.neovide_cursor_vfx_mode = "ripple"
  vim.g.neovide_scroll_animation_length = 0.3
  vim.g.neovide_input_macos_alt_is_meta = true
  vim.g.neovide_hide_mouse_when_typing = true
  vim.keymap.set(
    "n",
    "<M-CR>",
    ":let g:neovide_fullscreen = !g:neovide_fullscreen<CR>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.opt.guifont = { "BerkeleyMono Nerd Font", "h14", "#e-subpixelantialias" }
end
