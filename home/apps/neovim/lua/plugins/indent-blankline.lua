---@type LazyPluginSpec[]
return {
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup({
        space_char_blankline = " ",
      })
      vim.g.indent_blankline_filetype_exclude = {
        "dashboard",
        "fugitive",
        "help",
        "lazy",
        "NvimTree",
        "neogitstatus",
        "Trouble",
      }
    end,
  },
}
