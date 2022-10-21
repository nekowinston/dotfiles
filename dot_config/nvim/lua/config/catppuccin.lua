local colors = require("catppuccin.palettes").get_palette()
vim.g.catppuccin_flavour = "mocha"

local darkmode_overrides = {
  base = "#000000",
  crust = "#000000",
  mantle = "#000000",
  -- surface0 = "#101010",
  -- surface1 = "#141414",
  -- surface2 = "#181818",
  -- overlay1 = "#202020",
  -- overlay2 = "#242424",
  -- overlay3 = "#282828",
}

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
    dashboard = true, -- manually set
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
    vimwiki = true,
  },
  custom_highlights = {
    DashboardHeader = { fg = colors.pink },
    DashboardCenter = { fg = colors.peach },
    DashboardShortCut = { fg = colors.yellow },
    DashboardFooter = { fg = colors.maroon },
    FloatBorder = { fg = colors.overlay0 },
    TelescopeBorder = { link = "FloatBorder" },
  },
  color_overrides = {
    mocha = darkmode_overrides,
    macchiato = darkmode_overrides,
    frappe = darkmode_overrides,
  },
})

vim.api.nvim_command("colorscheme catppuccin")
