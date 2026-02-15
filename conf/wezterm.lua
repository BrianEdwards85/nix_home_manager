local config = wezterm.config_builder()
-- local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
local bar = wezterm.plugin.require("https://github.com/BrianEdwards85/bar.wezterm.git")

config.font = wezterm.font("DroidSansM Nerd Font")
config.font_size = 14.0

config.mux_enable_ssh_agent = false
config.default_ssh_auth_sock = string.format("%s/.gnupg/S.gpg-agent.ssh", wezterm.home_dir)

config.keys = {
	{
		key = "d",
		mods = "CTRL|SHIFT",
		action = wezterm.action.DetachDomain("CurrentPaneDomain"),
	},
	{
		key = "LeftArrow",
		mods = "CMD",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		key = "RightArrow",
		mods = "CMD",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		key = "LeftArrow",
		mods = "CMD|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "RightArrow",
		mods = "CMD|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "UpArrow",
		mods = "CMD|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "DownArrow",
		mods = "CMD|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
}

config.color_scheme = "tokyonight-storm"
config.tab_bar_at_bottom = true

config.window_background_opacity = 0.85

bar.apply_to_config(config)

return config
