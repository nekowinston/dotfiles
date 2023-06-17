---@type LazyPluginSpec[]
return {
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup({
        space_char_blankline = " ",
      })
      vim.g.indent_blankline_filetype_exclude = {
        "alpha",
        "fugitive",
        "help",
        "lazy",
        "NeogitCommitView",
        "NeogitConsole",
        "NeogitStatus",
        "NvimTree",
        "TelescopePrompt",
        "Trouble",
      }
    end,
  },
}
