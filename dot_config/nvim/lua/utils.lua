local function map(mode, shortcut, command, opt)
	vim.keymap.set(mode, shortcut, command, opt)
end

function Nmap(shortcut, command, opt)
	opt = opt or { noremap = true, silent = true }
	map("n", shortcut, command, opt)
end

function Imap(shortcut, command, opt)
	opt = opt or { noremap = true, silent = true }
	map("i", shortcut, command, opt)
end

function Xmap(shortcut, command, opt)
	opt = opt or { noremap = true, silent = true }
	map("x", shortcut, command, opt)
end
