---@type LazyPluginSpec[]
return {
  {
    "f-person/auto-dark-mode.nvim",
    cond = vim.fn.has("mac"),
    config = function()
      local autodm = require("auto-dark-mode")

      local update_neovide_background = function()
        if not vim.g.neovide then
          return
        end
        local ctp_present, ctp = pcall(require, "catppuccin.palettes")
        if ctp_present then
          vim.g.neovide_background_color = ctp.get_palette().base
        end
      end

      autodm.setup({
        set_dark_mode = function()
          vim.api.nvim_set_option("background", "dark")
          update_neovide_background()
        end,
        set_light_mode = function()
          vim.api.nvim_set_option("background", "light")
          update_neovide_background()
        end,
      })
      autodm.init()
    end,
  },
}
