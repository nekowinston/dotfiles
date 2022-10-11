local saga = require("lspsaga")
saga.init_lsp_saga({
  code_action_lightbulb = {
    enable = false,
  },
})

Nmap("gr", "<cmd>Lspsaga rename<cr>")
Nmap("gx", "<cmd>Lspsaga code_action<cr>")
Xmap("gx", ":<c-u>Lspsaga range_code_action<cr>")
Nmap("K", "<cmd>Lspsaga hover_doc<cr>")
Nmap("go", "<cmd>Lspsaga show_line_diagnostics<cr>")
Nmap("gj", "<cmd>Lspsaga diagnostic_jump_next<cr>")
Nmap("gk", "<cmd>Lspsaga diagnostic_jump_prev<cr>")

vim.cmd([[
	nnoremap <silent> <A-d> <cmd>lua require('lspsaga.floaterm').open_float_terminal()<CR>
	tnoremap <silent> <A-d> <C-\><C-n>:lua require('lspsaga.floaterm').close_float_terminal()<CR>
]])
