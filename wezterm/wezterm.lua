local wezterm = require("wezterm")
local act = wezterm.action

-- Set default padding
local default_padding = {
	left = 8,
	right = 8,
	top = 8,
	bottom = 8,
}

-- Set padding for Neovim (i.e., no padding)
local nvim_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

wezterm.on("update-right-status", function(window, pane)
	-- Get the current process name
	local process_name = pane:get_foreground_process_name()

	-- Check if Neovim is running in the active pane
	if process_name and process_name:find("nvim") then
		-- Remove padding when Neovim is detected
		window:set_config_overrides({
			window_padding = nvim_padding,
		})
	else
		-- Restore default padding when not in Neovim
		window:set_config_overrides({
			window_padding = default_padding,
		})
	end
end)

return {
	color_scheme = "nord",
	font = wezterm.font("VictorMono Nerd Font", { weight = "Regular", italic = false }),

	adjust_window_size_when_changing_font_size = false,

	font_size = 14.0,

	hide_tab_bar_if_only_one_tab = true,

	native_macos_fullscreen_mode = true,

	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},

	inactive_pane_hsb = {
		-- NOTE: these values are multipliers, applied on normal pane values
		saturation = 0.5,
		brightness = 0.8,
	},

	keys = {
		{
			key = "f",
			mods = "CMD|CTRL",
			action = act.ToggleFullScreen,
		},
		{
			key = "[",
			mods = "CMD",
			action = act.ActivatePaneDirection("Left"),
		},
		{
			key = "]",
			mods = "CMD",
			action = act.ActivatePaneDirection("Right"),
		},
		{
			key = "d",
			mods = "CMD",
			action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "d",
			mods = "CMD|SHIFT",
			action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "w",
			mods = "CMD",
			action = act.CloseCurrentPane({ confirm = false }),
		},
	},
}
