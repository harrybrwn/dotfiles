-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

hl.config({
	debug = {
		enable_stdout_logs = true,
		disable_logs = false,
	}
})

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
	output   = "",
	mode     = "preferred",
	position = "auto",
	scale    = "auto",
})

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
	hl.exec_cmd("waybar")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("hypridle")
end)

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env("XCURSOR_SIZE", "18")
hl.env("HYPRCURSOR_SIZE", "18")
hl.env("HYPRSHOT_DIR", os.getenv("HOME") .. "/Pictures/screenshots")
hl.env("GTK_THEME", "Adwaita:dark") -- set dark theme

local color_fg = "f31777ee"
local color_fg1 = "fcb203ee"
local color_fg2 = "e3e3e3ee"

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_in          = 5,
		gaps_out         = 10,
		border_size      = 0,
		col              = {
			active_border   = {
				-- colors = { "rgba(33ccffee)", "rgba(00ff99ee)" },
				colors = { "rgba(595959aa)" },
				angle = 45
			},
			-- inactive_border = "rgba(595959aa)",
			inactive_border = "rgba(" .. color_fg1 .. ")",
		},
		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = false,
		-- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
		allow_tearing    = false,
		layout           = "dwindle",
	},

	decoration = {
		rounding         = 6,
		rounding_power   = 2,
		-- Change transparency of focused and unfocused windows
		active_opacity   = 1.0,
		inactive_opacity = 1.0,
		shadow           = {
			enabled      = true,
			range        = 4,
			render_power = 3,
			color        = '0xee1a1a1a',
		},

		blur             = {
			enabled  = true,
			size     = 3,
			passes   = 1,
			vibrancy = 0.1696,
		},
	},
})

hl.window_rule {
	name = "no_focus",
	match = { class = "^$", title = "^$" },
	float = 1,
	fullscreen = 1,
	pin = 1,
}

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
	dwindle = {
		preserve_split = true, -- You probably want this
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
	master = {
		new_status = "master",
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
	scrolling = {
		fullscreen_on_one_column = true,
	},
})

hl.config({
	misc = {
		force_default_wallpaper  = 0,  -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo    = true, -- If true disables the random hyprland logo / anime girl background. :(
		disable_splash_rendering = true,
	},
})

hl.config({
	input = {
		kb_layout    = "us",
		kb_variant   = "",
		kb_model     = "",
		kb_options   = "",
		kb_rules     = "",
		follow_mouse = 1,
		sensitivity  = 0, -- -1.0 - 1.0, 0 means no modification.
		-- Keyboard speed
		repeat_delay = 300,
		repeat_rate  = 80,
		touchpad     = {
			natural_scroll = true,
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
	name        = "epic-mouse-v1",
	sensitivity = -0.5,
})

require('hyprland.keys')
require("hyprland.animations")

-- -- "Smart gaps" / "No gaps when only"
-- require('hyprland.smartgaps')
