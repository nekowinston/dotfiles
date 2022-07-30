-- vim:fdm=marker
pcall(require, "impatient")

-- packer {{{
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	print("Cloning packer ..")

	fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })

	-- install plugins + compile their configs
	vim.cmd("packadd packer.nvim")
	require("plugins")
	require("packer").sync()
end

require("utils")
require("lsp")

-- custom packer command
local packer_cmd = function(callback)
	return function()
		require("plugins")
		require("packer")[callback]()
	end
end

local function cmd(lhs, fun, opt)
	vim.api.nvim_create_user_command(lhs, fun, opt or {})
end

cmd("PackerClean", packer_cmd("clean"))
cmd("PackerCompile", packer_cmd("compile"))
cmd("PackerInstall", packer_cmd("install"))
cmd("PackerProfile", packer_cmd("profile"))
cmd("PackerStatus", packer_cmd("status"))
cmd("PackerSync", packer_cmd("sync"))
cmd("PackerUpdate", packer_cmd("update"))
-- }}}

-- prelude
vim.opt.laststatus = 3
vim.opt.list = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 5
vim.opt.showtabline = 2
vim.opt.sidescrolloff = 15
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.shadafile = nil

-- basic boring stuff
vim.g.mapleader = " "
vim.opt.mouse = "nv"

-- redefine word boundaries - '_' is a word seperator, this helps with snake_case
vim.cmd("set iskeyword-=_")

-- easier split navigation
Nmap("<C-J>", "<C-W>j<CR>")
Nmap("<C-K>", "<C-W>k<CR>")
Nmap("<C-L>", "<C-W>l<CR>")
Nmap("<C-H>", "<C-W>h<CR>")
-- escape :terminal easier
vim.cmd([[tnoremap <Esc> <C-\><C-n>]])

-- indentations settings
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
-- indentation autocmds for some filetypes
vim.cmd([[
" smol spaces for soydev
autocmd FileType html,css,js,jsreact,ts,tsreact,json,yaml setlocal ts=2 sw=2 sts=0 et
" Tabs, yikes
autocmd FileType go,lua setlocal ts=4 sw=4 sts=4 noet
" Spaces, based languages
autocmd FileType python,rust setlocal ts=4 sw=4 sts=4 et
]])

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.lua",
	callback = function()
		vim.defer_fn(function()
			if vim.fn.expand("%:p"):match(vim.fn.resolve(vim.fn.stdpath("config"))) then
				packer_cmd("compile")
			end
		end, 0)
	end,
})

if vim.g.neovide then
	vim.cmd("cd $HOME")
	vim.g.neovide_cursor_vfx_mode = "ripple"
	vim.g.neovide_input_macos_alt_is_meta = true
	vim.o.guifont = "VictorMono Nerd Font:h18"
	-- allow copy & paste in neovide,
	-- https://github.com/neovide/neovide/issues/1263
	vim.cmd([[
	  map <D-v> "+p<CR>
	  map! <D-v> <C-R>+
	  tmap <D-v> <C-R>+
	  vmap <D-c> "+y<CR>
	]])
end
