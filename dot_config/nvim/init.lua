-- vim:fdm=marker
pcall(require, "impatient")
pcall(require, "plugins")
pcall(require, "lsp")

-- true colors
vim.o.termguicolors = true
-- map leader to space
vim.g.mapleader = " "
vim.o.cmdheight = 0
-- line numbers
vim.o.mouse = ""
vim.o.number = true
vim.o.relativenumber = true
-- scroll offsets
vim.o.scrolloff = 5
vim.o.sidescrolloff = 15
-- show leading/trailing whitespace
vim.o.list = true
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
-- redefine word boundaries - '_' is a word seperator, this helps with snake_case
vim.opt.iskeyword:remove("_")

-- netrw is handled by nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

function Map(mode, shortcut, command, opt)
  opt = opt or { noremap = true, silent = true }
  vim.keymap.set(mode, shortcut, command, opt)
end

-- easier split navigation
Map("n", "<C-J>", "<C-W>j")
Map("n", "<C-K>", "<C-W>k")
Map("n", "<C-L>", "<C-W>l")
Map("n", "<C-H>", "<C-W>h")
Map("n", "<C-W>\\", ":vsplit<CR>")
Map("n", "<C-W>-", ":split<CR>")
Map("n", "<C-W>x", ":q<CR>")
-- merge conflicts
Map("n", "<leader>gd", ":Gvdiff!<CR>")
Map("n", "gdh", ":diffget //2<CR>")
Map("n", "gdl", ":diffget //3<CR>")
-- clipboard
Map({ "n", "v" }, "<leader>p", '"+p')
Map({ "n", "v" }, "<leader>y", '"+y')
-- escape :terminal easier
vim.cmd([[tnoremap <Esc> <C-\><C-n>]])

-- indentations settings
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 0
vim.o.expandtab = true
vim.cmd([[
autocmd FileType html,lua,css,js,jsreact,ts,tsreact,json,yaml setlocal ts=2 sw=2 sts=0 et
autocmd FileType go setlocal ts=4 sw=4 sts=4 noet
autocmd FileType python,rust setlocal ts=4 sw=4 sts=4 et
autocmd FileType markdown let g:table_mode_corner='|'
]])

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

vim.cmd([[
augroup toggleRelativeLineNumbers
	autocmd!

	autocmd InsertEnter,BufLeave,WinLeave,FocusLost * nested
		    \ if &l:number && empty(&buftype) |
		    \ setlocal norelativenumber |
		    \ endif
	autocmd InsertLeave,BufEnter,WinEnter,FocusGained * nested
		    \ if &l:number && empty(&buftype) |
		    \ setlocal relativenumber |
		    \ endif
augroup END
]])
