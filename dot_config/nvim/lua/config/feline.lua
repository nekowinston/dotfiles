local clrs = require("catppuccin.palettes.init").get_palette()
local ctp_feline = require("catppuccin.groups.integrations.feline")

ctp_feline.setup({
	assets = {
		left_separator = "",
		right_separator = "",
		bar = "█",
		mode_icon = " ",
	},
	sett = {
		show_modified = true,
		curr_dir = clrs.mauve,
		curr_file = clrs.blue,
	},
})

require("feline").setup({
	components = ctp_feline.get(),
	force_inactive = {
		filetypes = {
			"^packer$",
			"^startify$",
			"^fugitive$",
			"^fugitiveblame$",
			"^qf$",
			"^help$",
		},
		buftypes = {
			"^terminal$",
		},
		bufnames = {},
	},
})

-- local navic = require("nvim-navic")

-- local wbar = {
--     active = {},
--     inactive = {}
-- }
-- table.insert(wbar.active, {})
-- table.insert(wbar.active, {})
-- table.insert(wbar.active, {})

-- table.insert(wbar.active[1], {
-- 	provider = function()
-- 		return navic.get_location()
-- 	end,
-- 	enabled = function()
-- 		return navic.is_available()
-- 	end,
-- })
-- table.insert(wbar.active[3], {
-- 	provider = 'lsp_client_names'
-- })

-- require("feline").winbar.setup({ components = wbar })
