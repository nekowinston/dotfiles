-- vim:fdm=marker
pcall(require, "impatient")
pcall(require, "plugins")
pcall(require, "lsp")

-- true colors
vim.o.termguicolors = true
-- map leader to space
vim.g.mapleader = " "
-- allow mouse in normal/visual mode
vim.o.mouse = "nv"
-- line numbers
vim.o.number = true
vim.o.relativenumber = true
vim.o.numberwidth = 5
-- scroll offsets
vim.o.scrolloff = 5
vim.o.sidescrolloff = 15
-- show leading/trailing whitespace
vim.o.list = true
-- always show status & tab line
vim.o.laststatus = 3
vim.o.showtabline = 2
-- completion height
vim.o.pumheight = 15
-- split directions
vim.o.splitbelow = true
vim.o.splitright = true
-- redefine word boundaries - '_' is a word seperator, this helps with snake_case
vim.opt.iskeyword:remove("_")

-- easier split navigation
Nmap("<C-J>", "<C-W>j")
Nmap("<C-K>", "<C-W>k")
Nmap("<C-L>", "<C-W>l")
Nmap("<C-H>", "<C-W>h")
-- escape :terminal easier
vim.cmd([[tnoremap <Esc> <C-\><C-n>]])

-- indentations settings
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
-- indentation autocmds for some filetypes
vim.cmd([[
" smol spaces for soydev
autocmd FileType html,css,js,jsreact,ts,tsreact,json,yaml setlocal ts=2 sw=2 sts=0 et
" Tabs, yikes
autocmd FileType go,lua setlocal ts=4 sw=4 sts=4 noet
" Spaces, based languages
autocmd FileType python,rust setlocal ts=4 sw=4 sts=4 et
autocmd FileType markdown let g:table_mode_corner='|'
]])

-- auto-compile when lua files in `~/.config/nvim/*` change
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.lua",
	callback = function()
		local cfg_path = vim.fn.resolve(vim.fn.stdpath("config"))
		vim.defer_fn(function()
			if vim.fn.expand("%:p"):match(cfg_path) then
				vim.cmd("silent! PackerCompile")
			end
		end, 0)
	end,
})

-- neovide settings {{{
if vim.g.neovide then
	vim.cmd("cd $HOME")
	vim.g.neovide_cursor_vfx_mode = "ripple"
	vim.g.neovide_input_macos_alt_is_meta = true
	vim.o.guifont = "VictorMono Nerd Font:h18"
end
-- }}}
