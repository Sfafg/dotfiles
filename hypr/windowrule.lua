local suppressMaximizeRule = hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})

hl.window_rule({
	match = { class = "quickshell" },
	opacity = "0.1",
})

hl.workspace_rule({
	workspace = "1",
	layout = "master",
	monitor = "DP-1",
	default = true,
})

hl.workspace_rule({
	workspace = "2",
	layout = "scrolling",
	monitor = "HDMI-A-2",
	default = true,
})

for i = 3, 10 do
	if i % 2 == 0 then
		hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-2" })
	else
		hl.workspace_rule({ workspace = tostring(i), monitor = "DP-1" })
	end
end
