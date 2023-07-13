---@type LazyPluginSpec[]
return {
  {
    "andweeb/presence.nvim",
    enabled = true,
    config = function()
      local presence = require("presence")

      local function starts_with(self, str)
        return self:find("^" .. str) ~= nil
      end

      local home = vim.fn.expand("$HOME") .. "/Code/"

      local blacklist = {
        [vim.fn.resolve(home .. "work")] = "Using nvim at work.",
        [vim.fn.resolve(home .. "freelance")] = "Using nvim to freelance.",
      }

      ---@param activity string?
      ---@param info string?
      ---@return {text: string, state: boolean}
      local conceal = function(activity, info)
        local cur_file = vim.fn.expand("%:p")
        for k, v in pairs(blacklist) do
          if starts_with(cur_file, k) then
            return { text = v, state = true }
          end
        end
        if info ~= nil then
          return { text = activity .. " " .. info, state = false }
        end
        return { text = activity, state = false }
      end

      local v = vim.version()
      local vStr = string.format("v%d.%d.%d", v.major, v.minor, v.patch)

      presence:setup({
        auto_update = true,
        debounce_timeout = 10,
        neovim_image_text = "Neovim " .. vStr,
        -- Main image display (either "neovim" or "file")
        main_image = "file",
        show_time = true,
        buttons = function(_, repo_url)
          local concealed = conceal().state

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
                label = "Steal the code",
                url = repo_url,
              },
            }
          end
        end,
        file_assets = {
          ["astro"] = {
            "Astro",
            "https://github.com/withastro.png",
          },
          ["k8s.yaml"] = {
            "Kubernetes",
            "https://github.com/kubernetes.png",
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
            "https://github.com/prisma.png",
          },
          ["bu"] = {
            "Butane Config",
            "https://github.com/coreos.png",
          },
          ["ign"] = {
            "CoreOS Ignition",
            "https://github.com/coreos.png",
          },
        },
        -- Rich Presence text options
        editing_text = function(s)
          return conceal("Editing", s).text
        end,
        reading_text = function(s)
          return conceal("Reading", s).text
        end,
        file_explorer_text = function(s)
          return conceal("Browsing", s).text
        end,
        workspace_text = function(s)
          local concealed = conceal()
          if s ~= nil and not concealed.state then
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
