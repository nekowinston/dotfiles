local home = os.getenv("HOME")
local db = require("dashboard")

db.custom_header = function()
	local quotes = {
		"Demonic presence at unsafe levels.",
		"Rip and tear, until it is done.",
		"So you walk eternally through the shadow realms.",
		"The only thing they fear... is you.",
		"There he lies still, and ever more, in silent suffering.",
		"We will send unto them...only you.",
		"What you see now in this facility is the cost. Of progress.",
		"You can't just shoot a hole in the surface of mars!",
		"WARNING: The Slayer has entered the facility.",
		"DANGER: THE SLAYER HAS CONTROL OF THE BFG.",
	}
	local random_quote = quotes[math.random(#quotes)]
	return {
		[[]],
		[[ _    _ _____ _   _  _____ _____ _____ _   _       _   _ ________  ___]],
		[[| |  | |_   _| \ | |/  ___|_   _|  _  | \ | |     | | | |_   _|  \/  |]],
		[[| |  | | | | |  \| |\ `--.  | | | | | |  \| |     | | | | | | | .  . |]],
		[[| |/\| | | | | . ` | `--. \ | | | | | | . ` |     | | | | | | | |\/| |]],
		[[\  /\  /_| |_| |\  |/\__/ / | | \ \_/ / |\  |  _  \ \_/ /_| |_| |  | |]],
		[[ \/  \/ \___/\_| \_/\____/  \_/  \___/\_| \_/ (_)  \___/ \___/\_|  |_/]],
		[[]],
		random_quote,
		[[]],
	}
end

db.custom_center = {
	{
		icon = "  ",
		desc = "Restore latest session                  ",
		action = "SessionLoad",
	},
	{
		icon = "  ",
		desc = "Open Projects                           ",
		action = "Telescope project",
	},
	{
		icon = "  ",
		desc = "Find File                               ",
		action = "Telescope find_files find_command=rg,--hidden,--files",
	},
	{
		icon = "  ",
		desc = "File Browser                            ",
		action = "Telescope file_browser",
	},
	{
		icon = "  ",
		desc = "Find word                               ",
		action = "Telescope live_grep",
	},
	{
		icon = "  ",
		desc = "Open Settings                           ",
		action = function()
			vim.cmd("cd " .. home .. "/.config/nvim/")
			vim.cmd("edit init.lua")
		end
	},
}
