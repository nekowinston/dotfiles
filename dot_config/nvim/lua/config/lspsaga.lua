local saga = require("lspsaga")
saga.init_lsp_saga({
	symbol_in_winbar = {
		in_custom = true,
		enable = true,
		separator = " > ",
		show_file = true,
		click_support = function(node, clicks, button, modifier)
			-- To see all avaiable defails: vim.pretty_print(node)
			local st = node.range.start
			local en = node.range["end"]
			if button == "l" then
				if modifier == "c" then
					print("lspsaga") -- ctrl left click to print "lspsaga"
				end -- jump to node's ending line+char
				if clicks == 2 then
					-- double left click to visual select
					vim.fn.cursor(st.line + 1, st.character + 1)
					vim.cmd.normal("v")
					vim.fn.cursor(en.line + 1, en.character + 1)
				else -- jump to node's starting line+char
					vim.fn.cursor(st.line + 1, st.character + 1)
				end
			elseif button == "r" then
				if modifier == "c" then
					print("lspsaga") -- shift right click to print "lspsaga"
				end -- jump to node's ending line+char
				vim.fn.cursor(en.line + 1, en.character + 1)
			elseif button == "m" then
				-- middle click to visual select node
				vim.fn.cursor(st.line + 1, st.character + 1)
				vim.cmd.normal("v")
				vim.fn.cursor(en.line + 1, en.character + 1)
			end
		end,
	},
})

Nmap("gr", "<cmd>Lspsaga rename<cr>")
Nmap("gx", "<cmd>Lspsaga code_action<cr>")
Xmap("gx", ":<c-u>Lspsaga range_code_action<cr>")
Nmap("K", "<cmd>Lspsaga hover_doc<cr>")
Nmap("go", "<cmd>Lspsaga show_line_diagnostics<cr>")
Nmap("gj", "<cmd>Lspsaga diagnostic_jump_next<cr>")
Nmap("gk", "<cmd>Lspsaga diagnostic_jump_prev<cr>")
Nmap("<C-u>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1, '<c-u>')<cr>", {})
Nmap("<C-d>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1, '<c-d>')<cr>", {})

-- nullchilly winbar
local function get_file_name(include_path)
	local file_name = require("lspsaga.symbolwinbar").get_file_name()
	if vim.fn.bufname("%") == "" then
		return ""
	end
	if include_path == false then
		return file_name
	end
	-- Else if include path: ./lsp/saga.lua -> lsp > saga.lua
	local sep = vim.loop.os_uname().sysname == "Windows" and "\\" or "/"
	local path_list = vim.split(string.gsub(vim.fn.expand("%:~:.:h"), "%%", ""), sep)
	local file_path = ""
	for _, cur in ipairs(path_list) do
		file_path = (cur == "." or cur == "~") and "" or file_path .. cur .. " " .. "%#LspSagaWinbarSep#>%*" .. " %*"
	end
	return file_path .. file_name
end

local function config_winbar()
	local exclude = {
		["teminal"] = true,
		["toggleterm"] = true,
		["prompt"] = true,
		["NvimTree"] = true,
		["help"] = true,
	} -- Ignore float windows and exclude filetype
	if vim.api.nvim_win_get_config(0).zindex or exclude[vim.bo.filetype] then
		vim.wo.winbar = ""
	else
		local ok, lspsaga = pcall(require, "lspsaga.symbolwinbar")
		local sym
		if ok then
			sym = lspsaga.get_symbol_node()
		end
		local win_val = ""
		win_val = get_file_name(true) -- set to true to include path
		if sym ~= nil then
			win_val = win_val .. sym
		end
		vim.wo.winbar = win_val
	end
end

local events = { "BufEnter", "BufWinEnter", "CursorMoved" }
vim.api.nvim_create_autocmd(events, {
	pattern = "*",
	callback = function()
		config_winbar()
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "LspsagaUpdateSymbol",
	callback = function()
		config_winbar()
	end,
})

vim.cmd([[
	nnoremap <silent> <A-d> <cmd>lua require('lspsaga.floaterm').open_float_terminal()<CR>
	tnoremap <silent> <A-d> <C-\><C-n>:lua require('lspsaga.floaterm').close_float_terminal()<CR>
]])
