require("lspsaga").setup({
  lightbulb = {
    enable = false,
  },
  ui = {
    colors = require("catppuccin.groups.integrations.lsp_saga").custom_colors(),
    kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
  },
})

local nmap = function(key, cmd)
  vim.api.nvim_set_keymap("n", key, cmd, { noremap = true, silent = true })
end

nmap("gr", "<cmd>Lspsaga rename<cr>")
nmap("gx", "<cmd>Lspsaga code_action<cr>")
nmap("gx", ":<c-u>Lspsaga range_code_action<cr>")
nmap("K", "<cmd>Lspsaga hover_doc<cr>")
nmap("go", "<cmd>Lspsaga show_line_diagnostics<cr>")
nmap("gj", "<cmd>Lspsaga diagnostic_jump_next<cr>")
nmap("gk", "<cmd>Lspsaga diagnostic_jump_prev<cr>")

vim.cmd([[
	nnoremap <silent> <A-d> <cmd>lua require('lspsaga.floaterm').open_float_terminal()<CR>
	tnoremap <silent> <A-d> <C-\><C-n>:lua require('lspsaga.floaterm').close_float_terminal()<CR>
]])
