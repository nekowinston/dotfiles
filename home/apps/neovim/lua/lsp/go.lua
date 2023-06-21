local M = {}

M.setup = function(opts)
  require("go").setup({
    disable_defaults = true,
    fillstruct = "gopls",
    gofmt = "gofumpt",
    max_line_len = 120,
    tag_transform = false,
    icons = {
      breakpoint = " ",
      currentpos = " ",
    },
    lsp_cfg = opts,
    lsp_gofumpt = true,
    lsp_keymaps = false,
    lsp_codelens = true,
    lsp_diag_hdlr = true,
    lsp_diag_underline = true,
    lsp_diag_virtual_text = { space = 0, prefix = " " },
    lsp_diag_signs = true,
    lsp_diag_update_in_insert = false,
    lsp_document_formatting = false,
    lsp_inlay_hints = {
      enable = true,
      only_current_line = false,
      only_current_line_autocmd = "CursorHold",
      show_variable_name = true,
      parameter_hints_prefix = "󰊕 ",
      show_parameter_hints = true,
      other_hints_prefix = "=> ",
      highlight = "InlayHint",
    },
    gopls_remote_auto = true,
    gocoverage_sign = "█",
    sign_priority = 5,
    dap_debug = true,
    dap_debug_keymap = true,
    dap_debug_gui = true,
    dap_debug_vt = true,
    build_tags = "",
    textobjects = true,
    test_runner = "go",
    verbose_tests = true,
    run_in_floaterm = false,
    trouble = true,
    test_efm = false,
    luasnip = false,
  })
end

return M
