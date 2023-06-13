---@type LazyPluginSpec[]
return {
  {
    "Shatur/neovim-session-manager",
    opts = { autoload_mode = "CurrentDir" },
  },
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
        dashboard.button("n", "  New file", ":ene <bar> startinsert <cr>"),
        dashboard.button(
          "SPC fd",
          "  Find file",
          ":Telescope find_files<cr>"
        ),
        dashboard.button(
          "SPC fg",
          "  Live grep",
          ":Telescope live_grep<cr>"
        ),
        dashboard.button(
          "s",
          "  Show sessions",
          ":SessionManager load_session<cr>"
        ),
        dashboard.button("SPC fp", "  Projects", ":Telescope project<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
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
