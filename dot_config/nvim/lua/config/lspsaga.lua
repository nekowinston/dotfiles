local saga = require("lspsaga")
saga.init_lsp_saga()

Nmap("gr", "<cmd>Lspsaga rename<cr>")
Nmap("gx", "<cmd>Lspsaga code_action<cr>")
Xmap("gx", ":<c-u>Lspsaga range_code_action<cr>")
Nmap("K", "<cmd>Lspsaga hover_doc<cr>")
Nmap("go", "<cmd>Lspsaga show_line_diagnostics<cr>")
Nmap("gj", "<cmd>Lspsaga diagnostic_jump_next<cr>")
Nmap("gk", "<cmd>Lspsaga diagnostic_jump_prev<cr>")
-- Nmap("<C-u>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1, '<c-u>')<cr>", {})
-- Nmap("<C-d>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1, '<c-d>')<cr>", {})

-- vim.keymap.set("n", "<C-u>", function()
--     require("lspsaga.action").smart_scroll_with_saga(1)
-- end)
--   -- scroll up
-- vim.keymap.set("n", "<C-d>", function()
--     require("lspsaga.action").smart_scroll_with_saga(-1)
-- end)

vim.cmd([[
	nnoremap <silent> <A-d> <cmd>lua require('lspsaga.floaterm').open_float_terminal()<CR>
	tnoremap <silent> <A-d> <C-\><C-n>:lua require('lspsaga.floaterm').close_float_terminal()<CR>
]])
