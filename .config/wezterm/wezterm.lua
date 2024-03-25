local wezterm = require("wezterm")
local config = wezterm.config_builder()

local wallpapers = wezterm.home_dir .. "/Pictures/wallpapers"
local themes = {
	terafox = "terafox",
	neonnight = "Neon Night (Gogh)",
	nightfox = "nightfox",
	dracula = "Dracula (Gogh)",
	gruvbox = "GruvboxDark",
	tokyonight = "tokyonight",
	ayu = "Ayu Dark (Gogh)",
	onedark = "One Dark (Gogh)",
	nord = "nord",
	kanagawa = "Kanagawa (Gogh)",
	solarized = "Solarized Dark (Gogh)",
}
config.color_scheme = themes.terafox
config.background = {
	{
		source = { File = wallpapers .. "/" .. "cyber-city-dark.png" },
		-- source = { File = wallpapers .. '/' .. 'space-city.jpg' },
		-- source = { File = wallpapers .. '/' .. 'astro-desert.jpg' },
		hsb = {
			brightness = 0.08,
			hue = 1.0,
			saturation = 1.0,
		},
		horizontal_align = "Left",
		--horizontal_align = "Right",
		opacity = 1.0,
		height = "Cover",
	},
}
config.background = nil -- reset background
config.window_background_opacity = 1.0

-- Fonts
config.font_size = 10
config.font_dirs = { wezterm.home_dir .. "/.local/share/fonts" }
config.font = wezterm.font_with_fallback({
	-- "LiterationMono Nerd Font",
	-- "SauceCodePro Nerd Font",
	-- "FiraMono Nerd Font Mono",
	"RobotoMono Nerd Font Mono",
	"JetBrains Mono",
	"Noto Color Emoji",
	"Symbols Nerd Font Mono",
	"monospace",
})
config.warn_about_missing_glyphs = false

-- Windows
config.enable_scroll_bar = false
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.initial_rows = 60
config.initial_cols = 160
config.audible_bell = "Disabled"
wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
	local zoomed = ""
	if tab.active_pane.is_zoomed then
		zoomed = "[Z] "
	end
	local index = ""
	if #tabs > 1 then
		index = string.format("[%d/%d] ", tab.tab_index + 1, #tabs)
	end
	return zoomed .. index .. "lol" -- tab.active_pane.title
end)

-- Tab Bar
config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.switch_to_last_active_tab_when_closing_tab = false
config.tab_and_split_indices_are_zero_based = false
config.show_new_tab_button_in_tab_bar = false

-- Keys
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{ key = "F11", mods = nil, action = wezterm.action.ToggleFullScreen },
	{ key = "P", mods = "CTRL", action = wezterm.action.ActivateCommandPalette },
	-- replicate tmux keybindings
	{ key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "p", mods = "LEADER", action = wezterm.action.ActivateTabRelative(-1) },
	{ key = "n", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1) },
	{ key = "c", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	{
		key = "|",
		mods = "LEADER|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{
		key = config.leader.key,
		mods = "LEADER|CTRL",
		action = wezterm.action.SendKey({ key = config.leader.key, mods = "CTRL" }),
	},
	{
		key = "|",
		mods = "LEADER|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = '"',
		mods = "LEADER|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "H",
		mods = "LEADER",
		action = wezterm.action.PaneSelect({
			mode = "SwapWithActive",
		}),
	},
}

-- Disable default tab keybindings
if not config.enable_tab_bar then
	table.insert(config.keys, { key = "T", mods = "CTRL", action = wezterm.action.DisableDefaultAssignment })
end

return config
