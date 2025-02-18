local M = {}

local wezterm = require("wezterm")
local utils = require("config.utils")

M.apply = function(c)
  if not utils.is_linux() then
    return
  end

  c.exec_domains = {
    wezterm.exec_domain("systemd-scoped", function(cmd)
      local env = cmd.set_environment_variables

      local wrapped = {
        "systemd-run",
        "--user",
        "--scope",
        "--same-dir",
        "--collect",
        "--slice=app-wezterm_" .. tostring(wezterm.procinfo.pid()),
        "--unit=pane-" .. env.WEZTERM_PANE,
      }

      for _, arg in ipairs(cmd.args or { os.getenv("SHELL") }) do
        table.insert(wrapped, arg)
      end

      cmd.args = wrapped

      return cmd
    end),
  }
  c.default_domain = "systemd-scoped"
end

return M
