require("monitors")
require("bind")
require("autostart")
require("env")
require("windowrule")

hl.config({
	general = {
		gaps_in = 0,
		-- gaps_out = { left = 50, right = 50, top = 0, bottom = 50 },
		gaps_out = 0,

		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
		no_focus_fallback = true,

		border_size = 1,
		col = {
			active_border = {
				colors = {
					"rgba(cba6f7af)",
					"rgba(89b4faaf)",
				},
				angle = 45,
			},
			inactive_border = "rgba(585b70aa)",
		},
	},

	decoration = {
		rounding = 15,
		rounding_power = 2,

		active_opacity = 1.0,
		inactive_opacity = 1.0,
		fullscreen_opacity = 1,
		dim_special = 0.4,
		border_part_of_window = false,

		shadow = {
			enabled = true,
			range = 30,
			render_power = 10,
			color = 0x7F000000,
		},

		blur = {
			enabled = true,
			size = 9,
			passes = 3,
			vibrancy = 0.1696,
		},
	},

	cursor = {
		invisible = false,
		inactive_timeout = 1,
		persistent_warps = true,
	},

	dwindle = {
		preserve_split = true,
		special_scale_factor = 0.95,
	},

	master = {
		new_status = "slave",
		mfact = 0.73,
		allow_small_split = true,
		new_on_top = true,
	},

	scrolling = {
		direction = "down",
	},

	input = {
		kb_layout = "pl",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		follow_mouse = 2,

		sensitivity = -0.3,

		touchpad = {
			disable_while_typing = true,
			natural_scroll = true,
			middle_button_emulation = false,
		},
	},

	misc = {
		force_default_wallpaper = 1,
		disable_hyprland_logo = false,
		initial_workspace_tracking = 1,
		vrr = 3,
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("easy", { type = "spring", mass = 0.501, stiffness = 160.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })
