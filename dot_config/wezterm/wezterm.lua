-- vim:foldmethod=marker
local wezterm = require("wezterm")

-- fonts I like, with the settings I prefer {{{
-- kept seperately from the rest of the config so that I can easily change them
local fonts = {
	cascadia = {
		font = {
			family = "Cascadia Code",
			harfbuzz_features = {
				"ss01=1",
				"ss19=1",
			},
		},
		size = 18,
	},
	comic = {
		font = {
			family = "Comic Code Ligatures",
		},
		size = 18,
	},
	fira = {
		font = {
			family = "Fira Code",
			harfbuzz_features = {
				"cv06=1",
				"cv14=1",
				"cv32=1",
				"ss04=1",
				"ss07=1",
				"ss09=1",
			},
		},
		size = 18,
	},
	fantasque = {
		font = {
			family = "Fantasque Sans Mono",
			weight = "Regular",
		},
		size = 20,
	},
	victor = {
		font = {
			family = "Victor Mono",
			weight = "DemiBold",
		},
		size = 18,
	},
}

local function get_font(name)
	return {
		font = wezterm.font_with_fallback({
			fonts[name].font,
			"Nerd Font Symbols",
			"Apple Color Emoji",
		}),
		size = fonts[name].size,
	}
end
-- }}}

-- custom tab bar {{{
---@diagnostic disable-next-line: unused-local
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local RIGHT_DIVIDER = utf8.char(0xe0bc)
	local colours = config.resolved_palette.tab_bar

	local active_tab_index = 0
	for _, t in ipairs(tabs) do
		if t.is_active == true then
			active_tab_index = t.tab_index
		end
	end

	local active_bg = colours.active_tab.bg_color
	local active_fg = colours.active_tab.fg_color
	local inactive_bg = colours.inactive_tab.bg_color
	local inactive_fg = colours.inactive_tab.fg_color
	local new_tab_bg = colours.new_tab.bg_color

	local s_bg, s_fg, e_bg, e_fg

	-- the last tab
	if tab.tab_index == #tabs - 1 then
		if tab.is_active then
			s_bg = active_bg
			s_fg = active_fg
			e_bg = new_tab_bg
			e_fg = active_bg
		else
			s_bg = inactive_bg
			s_fg = inactive_fg
			e_bg = new_tab_bg
			e_fg = inactive_bg
		end
	elseif tab.tab_index == active_tab_index - 1 then
		s_bg = inactive_bg
		s_fg = inactive_fg
		e_bg = active_bg
		e_fg = inactive_bg
	elseif tab.is_active then
		s_bg = active_bg
		s_fg = active_fg
		e_bg = inactive_bg
		e_fg = active_bg
	else
		s_bg = inactive_bg
		s_fg = inactive_fg
		e_bg = inactive_bg
		e_fg = inactive_bg
	end
	return {
		{ Background = { Color = s_bg } },
		{ Foreground = { Color = s_fg } },
		{ Text = " " .. tab.tab_index + 1 .. ": " .. tab.active_pane.title .. " " },
		{ Background = { Color = e_bg } },
		{ Foreground = { Color = e_fg } },
		{ Text = RIGHT_DIVIDER },
	}
end)
-- }}}

local function get_os()
	local target = wezterm.target_triple
	if string.find(target, "linux") then
		return "linux"
	elseif string.find(target, "darwin") then
		return "macos"
	end
end

local window_padding = {
	linux = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	macos = {
		left = 2,
		right = 2,
		top = 2,
		bottom = 2,
	},
}

local function scheme_for_appearance(appearance)
	-- default to dark mode, so I don't burn out my eyes
	if not appearance:find("Dark") then
		return "Catppuccin Latte"
	else
		return "Catppuccin Mocha"
	end
end

local font = get_font("victor")
local act = wezterm.action

return {
	-- keyboard shortcuts {{{
	disable_default_key_bindings = false,
	leader = { key = "s", mods = "CTRL", timeout_milliseconds = 5000 },
	keys = {
		-- use 'Backslash' to split horizontally
		{
			key = "\\",
			mods = "LEADER",
			action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
		},
		-- and 'Minus' to split vertically
		{
			key = "-",
			mods = "LEADER",
			action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }),
		},
		-- 'hjkl' to move between panes
		{ key = "h", mods = "LEADER", action = act({ ActivatePaneDirection = "Left" }) },
		{ key = "j", mods = "LEADER", action = act({ ActivatePaneDirection = "Down" }) },
		{ key = "k", mods = "LEADER", action = act({ ActivatePaneDirection = "Up" }) },
		{ key = "l", mods = "LEADER", action = act({ ActivatePaneDirection = "Right" }) },
		-- -- Shift + 'hjkl' to resize panes
		{ key = "h", mods = "LEADER|SHIFT", action = act({ AdjustPaneSize = { "Left", 5 } }) },
		{ key = "j", mods = "LEADER|SHIFT", action = act({ AdjustPaneSize = { "Down", 5 } }) },
		{ key = "k", mods = "LEADER|SHIFT", action = act({ AdjustPaneSize = { "Up", 5 } }) },
		{ key = "l", mods = "LEADER|SHIFT", action = act({ AdjustPaneSize = { "Right", 5 } }) },
		-- numbers to navigate to tabs
		{ key = "1", mods = "LEADER", action = act({ ActivateTab = 0 }) },
		{ key = "2", mods = "LEADER", action = act({ ActivateTab = 1 }) },
		{ key = "3", mods = "LEADER", action = act({ ActivateTab = 2 }) },
		{ key = "4", mods = "LEADER", action = act({ ActivateTab = 3 }) },
		{ key = "5", mods = "LEADER", action = act({ ActivateTab = 4 }) },
		{ key = "6", mods = "LEADER", action = act({ ActivateTab = 5 }) },
		{ key = "7", mods = "LEADER", action = act({ ActivateTab = 6 }) },
		{ key = "8", mods = "LEADER", action = act({ ActivateTab = 7 }) },
		{ key = "9", mods = "LEADER", action = act({ ActivateTab = 8 }) },
		{ key = "9", mods = "LEADER", action = act({ ActivateTab = 9 }) },
		{ key = "0", mods = "LEADER", action = act({ ActivateTab = -1 }) },
		-- 'c' to create a new tab
		{ key = "c", mods = "LEADER", action = act({ SpawnTab = "CurrentPaneDomain" }) },
		-- 'x' to kill the current pane
		{ key = "x", mods = "LEADER", action = act({ CloseCurrentPane = { confirm = true } }) },
		-- 'z' to toggle the zoom for the current pane
		{ key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
		-- 'v' to visually select in the current pane
		{ key = "v", mods = "LEADER", action = "ActivateCopyMode" },
	},
	-- }}}
	-- font
	font = font.font,
	font_size = font.size,
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = true,
	hide_tab_bar_if_only_one_tab = true,
	tab_max_width = 32,
	-- window
	window_decorations = "RESIZE",
	window_padding = window_padding[get_os()],
	-- theme
	color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
	-- nightly only
	clean_exit_codes = { 130 },
}
