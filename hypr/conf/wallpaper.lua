-- awww wallpaper daemon: startup + picker keybind.
-- Env vars for the daemon live in environments.lua so they're set before launch.

local v = require("conf.variables")

local wallpapermenu = v.rofi_ui_dir .. "/wallpaper_menu_ui.sh"

hl.on("hyprland.start", function()
  hl.exec_cmd("uwsm app -- awww-daemon")
end)

hl.bind(v.mainMod .. " + W", hl.dsp.exec_cmd(wallpapermenu))
