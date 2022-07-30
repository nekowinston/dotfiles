function string.starts(self, str)
   return self:find('^' .. str) ~= nil
end

local conceal = function()
	local home = os.getenv("HOME")
	local blacklist = {
		[home .. "/git/work"] = "Working...",
		[home .. "/git/freelance"] = "Freelancing...",
		[home .. "/git/freelance"] = "Freelancing...",
	}

	local cur_file = vim.fn.expand("%:p")
	for k, v in pairs(blacklist) do
		if cur_file:starts(k) then
			return v
		end
	end
	return false
end

require("presence"):setup({
	-- General options
	auto_update = true,
	neovim_image_text = "The Soydev's Kryptonite",
	-- Main image display (either "neovim" or "file")
	main_image = "file",
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

		-- if not, return false
		return false
	end,
	debounce_timeout = 10,
	file_assets = {
		["k8s.yaml"] = {
			"Kubernetes",
			"https://raw.githubusercontent.com/kubernetes/kubernetes/master/logo/logo.png",
		},
		["Chart.yaml"] = {
			"Helm Chart",
			"https://raw.githubusercontent.com/helm/community/main/art/images/Logo-Tweak-Dark.png",
		},
		["helmfile.yaml"] = {
			"helmfile",
			"https://raw.githubusercontent.com/helm/community/main/art/images/Logo-Tweak-Dark.png",
		}
	},
	-- Rich Presence text options
	editing_text = function(s)
		local concealed = conceal()
		if concealed then
			return concealed
		end
		return "✍️  " .. s
	end,
	reading_text = function(s)
		local concealed = conceal()
		if concealed then
			return concealed
		end
		return "📖 " .. s
	end,
	file_explorer_text = function(s)
		local concealed = conceal()
		if concealed then
			return concealed
		end
		return "📁 " .. s
	end,
	workspace_text = function(s)
		local concealed = conceal()
		if s ~= nil and not concealed then
			return "🗂️  ".. s
		else
			return nil
		end
	end,
	git_commit_text = "Committing changes",
	plugin_manager_text = "🤹 Plugins",
	line_number_text = "L%s of %s",
})
