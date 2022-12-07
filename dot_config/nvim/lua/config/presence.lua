function string.starts(self, str)
  return self:find("^" .. str) ~= nil
end

local home = vim.fn.expand("$HOME") .. "/Code/"

local blacklist = {
  [vim.fn.resolve(home .. "work")] = "Using nvim at work.",
  [vim.fn.resolve(home .. "freelance")] = "Using nvim to freelance.",
}

local function get_chezmoi_output()
  local sp = io.popen("chezmoi managed -i files")
  if sp then
    local files = {}
    for line in sp:lines() do
      table.insert(files, vim.fn.expand("$HOME") .. "/" .. line)
    end
    sp:close()
    return files
  end
end

local chezmoi_managed = get_chezmoi_output()

local conceal = function()
  local cur_file = vim.fn.expand("%:p")
  if vim.tbl_contains(chezmoi_managed, cur_file) then
    return "Managing dotfiles"
  end
  for k, v in pairs(blacklist) do
    if cur_file:starts(k) then
      return v
    end
  end
  return false
end

local v = vim.version()
local vStr = string.format("v%d.%d.%d", v.major, v.minor, v.patch)

require("presence"):setup({
  -- General options
  auto_update = true,
  debounce_timeout = 10,
  neovim_image_text = "Masochism " .. vStr,
  -- Main image display (either "neovim" or "file")
  main_image = "file",
  show_time = false,
  -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
  ---@diagnostic disable-next-line: unused-local
  buttons = function(buffer, repo_url)
    -- ignore where no repo_url is set
    if repo_url == nil then
      return false
    end

    -- only show certain org/user repos, don't leak clients or work
    local visible_urls = {
      "github.com/catppuccin",
      "github.com/farbenfroh",
      "github.com/nekowinston",
    }

    -- check if repo_url is in the list of visible urls
    for _, visible_url in ipairs(visible_urls) do
      if repo_url:find(visible_url) then
        return {
          {
            label = "Steal the code",
            url = repo_url,
          },
        }
      end
    end

    -- if not, make funni
    return {
      {
        label = "Steal the code",
        url = "https://winston.sh/rrproductions/studio.git",
      },
    }
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
    local concealed = conceal()
    if concealed then
      return concealed
    end
    return "Editing " .. s
  end,
  reading_text = function(s)
    local concealed = conceal()
    if concealed then
      return concealed
    end
    return "Reading " .. s
  end,
  file_explorer_text = function(s)
    local concealed = conceal()
    if concealed then
      return concealed
    end
    return "Browsing " .. s
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
