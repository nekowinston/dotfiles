local colors = require("catppuccin.palettes").get_palette()
vim.g.catppuccin_flavour = "frappe"

require("catppuccin").setup({
  dim_inactive = {
    enable = true,
    shade = "dark",
    percentage = 0.15,
  },
  styles = {
    comments = { "italic" },
    conditionals = { "italic" },
  },
  integrations = {
    treesitter = true,
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { "italic" },
        hints = { "italic" },
        warnings = { "italic" },
        information = { "italic" },
      },
      underlines = {
        errors = { "underline" },
        hints = { "underline" },
        warnings = { "underline" },
        information = { "underline" },
      },
    },
    cmp = true,
    coc_nvim = false,
    lsp_saga = true,
    lsp_trouble = true,
    nvimtree = {
      enabled = false,
    },
    neotree = {
      enabled = true,
      show_root = false,
      transparent_panel = false,
    },
    which_key = true,
    indent_blankline = {
      enabled = true,
      colored_indent_levels = true,
    },
    barbar = false,
    bufferline = true,
    dashboard = false,
    fern = false,
    gitgutter = false,
    gitsigns = true,
    hop = false,
    leap = false,
    lightspeed = true,
    markdown = true,
    neogit = true,
    notify = false,
    symbols_outline = true,
    telekasten = false,
    telescope = true,
    ts_rainbow = true,
    vim_sneak = false,
  },
  custom_highlights = {
    DashboardShortCut = { fg = colors.yellow },
    DashboardHeader = { fg = colors.red },
    DashboardCenter = { fg = colors.peach },
    DashboardFooter = { fg = colors.maroon },
  },
})

vim.api.nvim_command("colorscheme catppuccin")

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    package.loaded["feline"] = nil
    package.loaded["catppuccin.groups.integrations.feline"] = nil
    require("config.feline")
  end,
})
