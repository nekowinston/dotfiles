-- vim:foldmethod=marker
local wezterm = require("wezterm")

-- fonts I like, with the settings I prefer {{{
-- kept seperately from the rest of the config so that I can easily change them
local fonts = {
	berkeley = {
		font = "Berkeley Mono",
		size = 16,
	},
	comic = {
		font = "Comic Code Ligatures",
		size = 18,
	},
	fantasque = {
		font = "Fantasque Sans Mono",
		size = 20,
	},
	operator = {
		font = {
			family = "Operator Mono",
			weight = "Book",
		},
		size = 18,
	},
	victor = {
		font = {
			family = "Victor Mono",
			weight = "DemiBold",
			harfbuzz_features = { "ss02=1" },
		},
		size = 18,
	},
}

local function get_font(name)
	return {
		font = wezterm.font_with_fallback({
			fonts[name].font,
			"Apple Color Emoji",
		}),
		size = fonts[name].size,
	}
end

-- }}}

-- superscript/subscript {{{
local function numberStyle(number, script)
	local scripts = {
		superscript = {
			"⁰",
			"¹",
			"²",
			"³",
			"⁴",
			"⁵",
			"⁶",
			"⁷",
			"⁸",
			"⁹",
		},
		subscript = {
			"₀",
			"₁",
			"₂",
			"₃",
			"₄",
			"₅",
			"₆",
			"₇",
			"₈",
			"₉",
		},
	}
	local numbers = scripts[script]
	local number_string = tostring(number)
	local result = ""
	for i = 1, #number_string do
		local char = number_string:sub(i, i)
		local num = tonumber(char)
		if num then
			result = result .. numbers[num + 1]
		else
			result = result .. char
		end
	end
	return result
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

	local active_bg = config.resolved_palette.ansi[6]
	local active_fg = colours.background
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

	local muxpanes = wezterm.mux.get_tab(tab.tab_id):panes()
	local count = #muxpanes == 1 and "" or #muxpanes

	return {
		{ Background = { Color = s_bg } },
		{ Foreground = { Color = s_fg } },
		{
			Text = " "
				.. tab.tab_index + 1
				.. ": "
				.. tab.active_pane.title
				.. numberStyle(count, "superscript")
				.. " ",
		},
		{ Background = { Color = e_bg } },
		{ Foreground = { Color = e_fg } },
		{ Text = RIGHT_DIVIDER },
	}
end)
-- }}}

-- custom status {{{
---@diagnostic disable-next-line: unused-local
wezterm.on("update-status", function(window, pane)
	local palette = window:effective_config().resolved_palette
	local firstTabActive = window:mux_window():tabs_with_info()[1].is_active

	local RIGHT_DIVIDER = utf8.char(0xe0b0)
	local text = "   "

	if window:leader_is_active() then
		text = "   "
	end

	local divider_bg = firstTabActive and palette.ansi[6] or palette.tab_bar.inactive_tab.bg_color

	window:set_left_status(wezterm.format({
		{ Foreground = { Color = palette.background } },
		{ Background = { Color = palette.ansi[5] } },
		{ Text = text },
		{ Background = { Color = divider_bg } },
		{ Foreground = { Color = palette.ansi[5] } },
		{ Text = RIGHT_DIVIDER },
	}))

	-- an idea for a future right hand side info?
	-- window:set_right_status(wezterm.format({
	-- 	{ Foreground = { Color = palette.tab_bar.background } },
	-- 	{ Background = { Color = palette.ansi[8] } },
	-- 	{ Text = RIGHT_DIVIDER },
	-- 	{ Background = { Color = palette.ansi[8]  } },
	-- 	{ Foreground = { Color = palette.background } },
	-- 	{ Text = '   [||      ]   12.8% ' },
	-- }))
end)
-- }}}

local darkTheme = "Catppuccin Frappe"
local lightTheme = "Catppuccin Latte"

local function scheme_for_appearance(appearance)
	wezterm.log_info(appearance)
	if string.match(wezterm.target_triple, "linux") then
		return darkTheme
	end
	if appearance:find("Dark") then
		return darkTheme
	else
		return lightTheme
	end
end

local font = get_font("berkeley")
local act = wezterm.action

return {
	disable_default_key_bindings = true,
	-- keyboard shortcuts {{{
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
		{ key = "1", mods = "SUPER", action = act({ ActivateTab = 0 }) },
		{ key = "2", mods = "SUPER", action = act({ ActivateTab = 1 }) },
		{ key = "3", mods = "SUPER", action = act({ ActivateTab = 2 }) },
		{ key = "4", mods = "SUPER", action = act({ ActivateTab = 3 }) },
		{ key = "5", mods = "SUPER", action = act({ ActivateTab = 4 }) },
		{ key = "6", mods = "SUPER", action = act({ ActivateTab = 5 }) },
		{ key = "7", mods = "SUPER", action = act({ ActivateTab = 6 }) },
		{ key = "8", mods = "SUPER", action = act({ ActivateTab = 7 }) },
		{ key = "9", mods = "SUPER", action = act({ ActivateTab = 8 }) },
		{ key = "9", mods = "SUPER", action = act({ ActivateTab = 9 }) },
		{ key = "0", mods = "SUPER", action = act({ ActivateTab = -1 }) },
		-- 'c' to create a new tab
		{ key = "c", mods = "LEADER", action = act({ SpawnTab = "CurrentPaneDomain" }) },
		-- 'x' to kill the current pane
		{ key = "x", mods = "LEADER", action = act({ CloseCurrentPane = { confirm = true } }) },
		-- 'z' to toggle the zoom for the current pane
		{ key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
		-- 'v' to visually select in the current pane
		{ key = "v", mods = "LEADER", action = "ActivateCopyMode" },
		-- 'r' to rotate panes
		{ key = "r", mods = "LEADER", action = act.RotatePanes("Clockwise") },
		{ key = " ", mods = "LEADER", action = act.QuickSelect },
		{
			key = "o",
			mods = "LEADER",
			action = wezterm.action.QuickSelectArgs({
				label = "open url",
				patterns = {
					"https?://\\S+",
				},
				action = wezterm.action_callback(function(window, pane)
					local url = window:get_selection_text_for_pane(pane)
					wezterm.log_info("opening: " .. url)
					wezterm.open_with(url)
				end),
			}),
		},
		-- copypasta
		{ key = "Enter", mods = "ALT", action = act.ToggleFullScreen },

		{ key = "-", mods = "CTRL", action = act.DecreaseFontSize },
		{ key = "-", mods = "SUPER", action = act.DecreaseFontSize },
		{ key = "=", mods = "CTRL", action = act.IncreaseFontSize },
		{ key = "=", mods = "SUPER", action = act.IncreaseFontSize },
		{ key = "0", mods = "CTRL", action = act.ResetFontSize },
		{ key = "0", mods = "SUPER", action = act.ResetFontSize },

		{ key = "c", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
		{ key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
		{ key = "v", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },
		{ key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },

		{ key = "f", mods = "SHIFT|CTRL", action = act.Search("CurrentSelectionOrEmptyString") },
		{ key = "f", mods = "SUPER", action = act.Search("CurrentSelectionOrEmptyString") },

		{ key = "l", mods = "SHIFT|CTRL", action = act.ShowDebugOverlay },

		{ key = "p", mods = "LEADER", action = act.PaneSelect({ alphabet = "asdfghjkl;", mode = "Activate" }) },
		{ key = "P", mods = "LEADER", action = act.PaneSelect({ alphabet = "asdfghjkl;", mode = "SwapWithActive" }) },

		{ key = "p", mods = "SUPER", action = act.PaneSelect({ alphabet = "asdfghjkl;", mode = "Activate" }) },
		{ key = "P", mods = "SUPER", action = act.PaneSelect({ alphabet = "asdfghjkl;", mode = "SwapWithActive" }) },
		{ key = "R", mods = "LEADER", action = act.ReloadConfiguration },

		-- mostly OS defaults
		{ key = "n", mods = "SHIFT|CTRL", action = act.SpawnWindow },
		{ key = "n", mods = "SUPER", action = act.SpawnWindow },
		{ key = "t", mods = "SHIFT|CTRL", action = act.SpawnTab("CurrentPaneDomain") },
		{ key = "t", mods = "SUPER", action = act.SpawnTab("CurrentPaneDomain") },
		{ key = "w", mods = "SHIFT|CTRL", action = act.CloseCurrentTab({ confirm = true }) },
		{ key = "w", mods = "SUPER", action = act.CloseCurrentTab({ confirm = true }) },
	},
	-- }}}
	-- font
	font = font.font,
	font_size = font.size,
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = true,
	tab_max_width = 32,
	-- window
	window_decorations = "RESIZE",
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	inactive_pane_hsb = {
		saturation = 1.0,
		brightness = 0.8,
	},
	-- don't attempt to resize the window (tiling wm)
	adjust_window_size_when_changing_font_size = false,
	-- theme
	color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
	-- nightly only
	clean_exit_codes = { 130 },
	-- bell
	audible_bell = "Disabled",
	-- biggest mistake
	max_fps = 240,
	-- scrollbar, currently hidden by default, but better make sure
	enable_scroll_bar = false,
}
