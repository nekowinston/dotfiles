return {
  {
    "andweeb/presence.nvim",
    config = function()
      local presence = require("presence")

      function string.starts(self, str)
        return self:find("^" .. str) ~= nil
      end

      local home = vim.fn.expand("$HOME") .. "/Code/"

      local blacklist = {
        [vim.fn.resolve(home .. "work")] = "Using nvim at work.",
        [vim.fn.resolve(home .. "freelance")] = "Using nvim to freelance.",
        [vim.fn.resolve(vim.fn.stdpath("config"))] = "Configuring nvim. ("
          .. require("lazy").stats().count
          .. " plugins)",
      }

      local conceal = function(activity, info)
        local cur_file = vim.fn.expand("%:p")
        for k, v in pairs(blacklist) do
          if cur_file:starts(k) then
            return v
          end
        end
        if info ~= nil then
          return activity .. " " .. info
        end
      end

      local v = vim.version()
      local vStr = string.format("v%d.%d.%d", v.major, v.minor, v.patch)

      presence:setup({
        -- General options
        auto_update = true,
        debounce_timeout = 10,
        neovim_image_text = "Neovim " .. vStr,
        -- Main image display (either "neovim" or "file")
        main_image = "file",
        show_time = false,
        buttons = function(buffer, repo_url)
          local concealed = conceal()
          if concealed then
            return {
              {
                label = "View my config",
                url = "https://github.com/nekowinston/dotfiles",
              },
            }
          else
            return {
              {
                label = "View the repository",
                url = repo_url,
              },
            }
          end
        end,
        file_assets = {
          ["k8s.yaml"] = {
            "Kubernetes",
            "https://avatars.githubusercontent.com/u/13629408",
          },
          ["Chart.yaml"] = {
            "Helm Chart",
            "https://raw.githubusercontent.com/helm/community/main/art/images/Logo-Tweak-Dark.png",
          },
          ["helmfile.yaml"] = {
            "helmfile",
            "https://raw.githubusercontent.com/helm/community/main/art/images/Logo-Tweak-Dark.png",
          },
          ["prisma"] = {
            "Prisma",
            "https://avatars.githubusercontent.com/u/17219288",
          },
          ["bu"] = {
            "Butane Config",
            "https://avatars.githubusercontent.com/u/3730757",
          },
          ["ign"] = {
            "CoreOS Ignition",
            "https://avatars.githubusercontent.com/u/3730757",
          },
        },
        -- Rich Presence text options
        editing_text = function(s)
          return conceal("Editing", s)
        end,
        reading_text = function(s)
          return conceal("Reading", s)
        end,
        file_explorer_text = function(s)
          return conceal("Browsing", s)
        end,
        workspace_text = function(s)
          local concealed = conceal()
          if s ~= nil and not concealed then
            return "Working on " .. s
          else
            return nil
          end
        end,
        git_commit_text = "Committing changes",
        plugin_manager_text = "Managing Plugins",
      })
    end,
  },
}
