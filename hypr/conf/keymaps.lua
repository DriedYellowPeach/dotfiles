-- Keybindings. Menu/wallpaper/clipboard/statusbar binds live in their own
-- modules; this file holds window mgmt, focus, workspaces, media keys.
-- See https://wiki.hypr.land/Configuring/Basics/Binds/ for more.

local v = require("conf.variables")
local mod = v.mainMod

-- Apps
hl.bind(mod .. " + E", hl.dsp.exec_cmd(v.fileManager))
hl.bind(mod .. " + T", hl.dsp.exec_cmd(v.terminal))
hl.bind(mod .. " + L", hl.dsp.exec_cmd("hyprlock"))

-- Window management
-- NOTE: 0.55 has a known quirk where fullscreen(mode=0) doesn't toggle back;
--       using "maximized" + action=toggle per project advice.
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))

-- Layout
hl.bind(mod .. " + J", hl.dsp.layout("togglesplit"))

-- Screenshots (hyprshot)
hl.bind("Print",           hl.dsp.exec_cmd("hyprshot -m output --clipboard-only"))
hl.bind(mod .. " + Print", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))

-- Focus movement
hl.bind(mod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Workspaces 1-10 (key 0 -> ws 10)
for i = 1, 10 do
  local key = i % 10
  hl.bind(mod .. " + " .. key,           hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + SHIFT + " .. key,   hl.dsp.window.move({ workspace = i }))
end

-- Scratchpad
hl.bind(mod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through workspaces with mainMod + wheel
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Mouse drag move/resize
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume / mic / brightness (works while locked; key-repeat for ramps)
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),       { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),      { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                   { locked = true, repeating = true })

-- Media transport (playerctl) — works while locked
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
