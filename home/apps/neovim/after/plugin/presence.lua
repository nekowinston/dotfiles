local present, presence = pcall(require, "presence")

if not present then
  return
end

function string.starts(self, str)
  return self:find("^" .. str) ~= nil
end

local home = vim.fn.expand("$HOME") .. "/Code/"

local blacklist = {
  [vim.fn.resolve(home .. "work")] = "Using nvim at work.",
  [vim.fn.resolve(home .. "freelance")] = "Using nvim to freelance.",
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
  -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
  ---@diagnostic disable-next-line: unused-local
  buttons = {
    {
      label = "Steal the code",
      url = "https://git.winston.sh/winston/holy-grail.git",
    },
  },
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
      return "Masochism " .. vStr
    end
  end,
  git_commit_text = "Committing changes",
  plugin_manager_text = "Managing Plugins",
})
