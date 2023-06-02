---@type LazyPluginSpec[]
return {
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        "  ,-.       _,---._ __  / \\  ",
        " /  )    .-'       `./ /   \\ ",
        "(  (   ,'            `/    /|",
        " \\  `-\"             \\'\\   / |",
        "  `.              ,  \\ \\ /  |",
        "   /`.          ,'-`----Y   |",
        "  (            ;        |   '",
        "  |  ,-.    ,-'         |  / ",
        "  |  | (   |            | /  ",
        "  )  |  \\  `.___________|/   ",
        "  `--'   `--'                ",
      }
      dashboard.section.buttons.val = {
        dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("q", "󰅚  Quit NVIM", ":qa<CR>"),
      }
      local version = vim.version()
      dashboard.section.footer.val = "neovim v"
        .. version.major
        .. "."
        .. version.minor
        .. "."
        .. version.patch
        .. "      "
        .. require("lazy").stats().count
        .. " plugins"
      dashboard.config.opts.noautocmd = true
      alpha.setup(dashboard.config)
    end,
  },
}
