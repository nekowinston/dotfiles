return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      require("catppuccin").setup({
        transparent_background = not vim.g.neovide,
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
              errors = { "undercurl" },
              hints = { "undercurl" },
              warnings = { "undercurl" },
              information = { "undercurl" },
            },
          },
          cmp = true,
          lsp_trouble = true,
          nvimtree = true,
          which_key = true,
          indent_blankline = {
            enabled = true,
            colored_indent_levels = true,
          },
          navic = {
            enabled = true,
            custom_bg = "NONE",
          },
          gitsigns = true,
          lightspeed = true,
          markdown = true,
          neogit = true,
          symbols_outline = true,
          ts_rainbow = true,
          vimwiki = true,
        },
        highlight_overrides = {
          all = function(colors)
            return {
              -- borders
              FloatBorder = { fg = colors.overlay0 },
              LspInfoBorder = { link = "FloatBorder" },
              NvimTreeWinSeparator = { link = "FloatBorder" },
              WhichKeyBorder = { link = "FloatBorder" },
              -- telescope
              TelescopeBorder = { link = "FloatBorder" },
              TelescopeTitle = { fg = colors.text },
              TelescopeSelection = { link = "Selection" },
              TelescopeSelectionCaret = { link = "Selection" },
              -- pmenu
              PmenuSel = { link = "Selection" },
              -- bufferline
              BufferLineTabSeparator = { link = "FloatBorder" },
              BufferLineSeparator = { link = "FloatBorder" },
              BufferLineOffsetSeparator = { link = "FloatBorder" },
              --
              FidgetTitle = { fg = colors.subtext1 },
              FidgetTask = { fg = colors.subtext0 },
            }
          end,
          -- mocha = function(colors)
          --   return {
          --     Selection = { bg = "#121212", fg = colors.text },
          --     Comment = { fg = colors.surface2, style = { "italic" } },
          --     InlayHint = { fg = colors.surface0, style = { "italic" } },
          --     WinSeparator = { fg = colors.surface2 },
          --   }
          -- end,
        },
        -- color_overrides = {
        --   mocha = {
        --     base = "#000000",
        --     crust = "#010101",
        --     mantle = "#020202",
        --   },
        -- },
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
