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

hl.window_rule({
	match = { title = "VRendererTest" },
	float = true,
})

hl.window_rule({
	match = { title = "Vulkan" },
	float = true,
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
	monitor = "HDMI-A-3",
	default = true,
})

for i = 3, 10 do
	local monitor = i % 2 == 0 and "HDMI-A-3" or "DP-1"
	hl.workspace_rule({ workspace = tostring(i), monitor = monitor })
end
