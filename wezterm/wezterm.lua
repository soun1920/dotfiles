month = os.date("*t").month
local wezterm = require("wezterm")

return {
	colors = {
		tab_bar = {
			background = "#1b1f2f",

			active_tab = {
				bg_color = "#44716a",
				fg_color = "#c6c8d1",
				intensity = "Normal",
				underline = "None",
				italic = false,
				strikethrough = false,
			},
		},
	},

	color_scheme = "iceberg-dark",
	default_prog = { "C:/Program Files/PowerShell/7/pwsh.exe", "-nologo" },
	default_domain = "WSL:Ubuntu",
	--  if month >= 9 then
	--    window_background_image =
	-- window_background_image = "C:/Users/aw5qm/.config/wezterm/anthony-xiong-Bf68Hqnw2zk-unsplash.jpg",
	window_background_image_hsb = {
		-- Darken the background image by reducing it to 1/3rd
		brightness = 0.14,
		-- You can adjust the hue by scaling its value.
		-- a multiplier of 1.0 leaves the value unchanged.
		-- hue = 1.0,

		-- You can adjust the saturation also.
		saturation = 1.0,
	},
	use_ime = true,
	font_size = 17,
	hide_tab_bar_if_only_one_tab = true,
	adjust_window_size_when_changing_font_size = true,
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	text_background_opacity = 0.1,
	enable_scroll_bar = false,
	automatically_reload_config = true,
}
