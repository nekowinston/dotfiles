local wezterm = require("wezterm")

local M = {}

M.get_font = function(name)
	-- fonts I like, with the settings I prefer
	-- kept seperately from the rest of the config so that I can easily change them
	local fonts = {
		berkeley = {
			font = {
				family = "Berkeley Mono",
				weight = "Bold",
			},
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
		victor = {
			font = {
				family = "Victor Mono",
				weight = "DemiBold",
				harfbuzz_features = { "ss02=1" },
			},
			size = 18,
		},
	}

	return {
		font = wezterm.font_with_fallback({
			fonts[name].font,
			"Apple Color Emoji",
		}),
		size = fonts[name].size,
	}
end

-- superscript/subscript
M.numberStyle = function(number, script)
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

return M
