local saga = require("lspsaga")
saga.init_lsp_saga({
  symbol_in_winbar = {
    in_custom = true,
  },
  code_action_lightbulb = {
    enable = false,
  },
})

Map("n", "gr", "<cmd>Lspsaga rename<cr>")
Map("n", "gx", "<cmd>Lspsaga code_action<cr>")
Map("n", "gx", ":<c-u>Lspsaga range_code_action<cr>")
Map("n", "K", "<cmd>Lspsaga hover_doc<cr>")
Map("n", "go", "<cmd>Lspsaga show_line_diagnostics<cr>")
Map("n", "gj", "<cmd>Lspsaga diagnostic_jump_next<cr>")
Map("n", "gk", "<cmd>Lspsaga diagnostic_jump_prev<cr>")

vim.cmd([[
	nnoremap <silent> <A-d> <cmd>lua require('lspsaga.floaterm').open_float_terminal()<CR>
	tnoremap <silent> <A-d> <C-\><C-n>:lua require('lspsaga.floaterm').close_float_terminal()<CR>
]])
