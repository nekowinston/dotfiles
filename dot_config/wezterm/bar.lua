local wezterm = require("wezterm")
local fonts = require("fonts")

local DIVIDERS = {
	LEFT = utf8.char(0xe0be),
	RIGHT = utf8.char(0xe0bc),
}

-- custom tab bar
---@diagnostic disable-next-line: unused-local
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
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
	local index = tab.tab_index + 1 .. ": "

	return {
		{ Background = { Color = s_bg } },
		{ Foreground = { Color = s_fg } },
		{
			Text = " " .. index .. tab.active_pane.title .. fonts.numberStyle(count, "superscript") .. " ",
		},
		{ Background = { Color = e_bg } },
		{ Foreground = { Color = e_fg } },
		{ Text = DIVIDERS.RIGHT },
	}
end)

-- custom status
---@diagnostic disable-next-line: unused-local
wezterm.on("update-status", function(window, pane)
	local palette = window:effective_config().resolved_palette
	local firstTabActive = window:mux_window():tabs_with_info()[1].is_active

	local leader_text = "   "

	if window:leader_is_active() then
		leader_text = "   "
	end

	local divider_bg = firstTabActive and palette.ansi[6] or palette.tab_bar.inactive_tab.bg_color

	window:set_left_status(wezterm.format({
		{ Foreground = { Color = palette.background } },
		{ Background = { Color = palette.ansi[5] } },
		{ Text = leader_text },
		{ Background = { Color = divider_bg } },
		{ Foreground = { Color = palette.ansi[5] } },
		{ Text = DIVIDERS.RIGHT },
	}))
	window:set_right_status(wezterm.format({
		{ Background = { Color = palette.background } },
		{ Foreground = { Color = palette.ansi[6] } },
		{ Text = os.date(" %H:%M ") },
	}))
end)
