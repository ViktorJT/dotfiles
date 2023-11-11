local wezterm = require 'wezterm'
local act = wezterm.action

return {
    color_scheme = "nord",
    font = wezterm.font('VictorMono Nerd Font', { weight = 'Regular', italic = false }),

    adjust_window_size_when_changing_font_size = false,

    font_size = 16.0,

    hide_tab_bar_if_only_one_tab = true,

    native_macos_fullscreen_mode = true,

    -- window_padding = {
    --     left = 8, right = 8,
    --     top = 8, bottom = 8,
    -- },

    inactive_pane_hsb = {
        -- NOTE: these values are multipliers, applied on normal pane values
        saturation = 0.5,
        brightness = 0.8,
    },

    keys = {
        {
            key = 'f',
            mods = 'CMD|CTRL',
            action = act.ToggleFullScreen,
        },
        {
            key = '[',
            mods = 'CMD',
            action = act.ActivatePaneDirection 'Left',
        },
        {
            key = ']',
            mods = 'CMD',
            action = act.ActivatePaneDirection 'Right',
        },
        {
            key = 'd',
            mods = 'CMD',
            action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
        },
        {
            key = 'd',
            mods = 'CMD|SHIFT',
            action = act.SplitVertical { domain = 'CurrentPaneDomain' },
        },
        {
            key = 'w',
            mods = 'CMD',
            action = act.CloseCurrentPane { confirm = false },
        },
    },
}
