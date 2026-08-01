local terminal = "kitty"
local fileManager = "thunar"
local browser = "firefox"
local screen_grab = "grimblast --notify copysave area"
local clipboard = "cliphist list | tofi -c ~/.config/tofi/configV | cliphist decode | wl-copy"
local controlCenter = "qs ipc call controlCenter toggle"
local appRunner = "qs ipc call appRunner toggle"
local shutdownMenu = "qs ipc call shutdownMenu toggle"
local statusBar = "qs ipc call statusBar toggle"

local mainMod = "SUPER"

--- Program shortcuts ---
hl.bind(
	mainMod .. " + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(screen_grab))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd(clipboard))
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd(shutdownMenu))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(appRunner))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd(controlCenter))
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(statusBar))

--- Windows controls ---
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + TAB", function()
	local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()
	if not workspace then
		return
	end
	local layout = workspace.tiled_layout
	if layout == "master" then
		hl.dispatch(hl.dsp.layout("swapwithmaster"))
	elseif layout == "diwndle" then
		hl.dispatch(hl.dsp.layout("togglesplit"))
	elseif layout == "scrolling" then
		hl.dispatch(hl.dsp.layout("consume_or_expel prev"))
	end
end)

hl.bind(mainMod .. " + C", hl.dsp.window.close())

--- Move focus ---
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

--- Resize windows ---
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })

--- Move windows ---
hl.bind(mainMod .. " + CONTROL + h", hl.dsp.window.move({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CONTROL + l", hl.dsp.window.move({ x = 20, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CONTROL + k", hl.dsp.window.move({ x = 0, y = -20, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CONTROL + j", hl.dsp.window.move({ x = 0, y = 20, relative = true }), { repeating = true })

-- hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + SHIFT + S", function()
	local id = hl.get_active_workspace().name
	hl.dispatch(hl.dsp.window.move({ workspace = "special:magic" .. id }))
end)

--- Mouse navigation ---
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

--- Move workspaces ---
-- hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("special:magic"))
hl.bind(mainMod .. " + S", function()
	local id = hl.get_active_workspace().name
	hl.dispatch(hl.dsp.workspace.toggle_special("magic" .. id))
end)
for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
