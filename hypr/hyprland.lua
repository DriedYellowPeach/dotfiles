-- Hyprland 0.55+ Lua configuration entry point.
-- See https://wiki.hypr.land/Configuring/Start/
--
-- Modules are loaded via require(); each gets its own Lua scope so an
-- error in one file does not prevent the others from loading.
-- Each module mirrors a file from the old hyprland.conf + conf/*.conf set.

-- Load order matters where one module's setup depends on env / config set
-- by an earlier one (e.g. wallpaper daemon needs env vars first).
require("conf.variables")     -- pure data; required by other modules
require("conf.environments")  -- env vars (before any process that reads them)
require("conf.monitors")      -- monitor + workspace rules + login focus
require("conf.input")         -- keyboard / pointer settings
require("conf.look_n_feel")   -- general / decoration / animations / layouts
require("conf.window")        -- window rules
require("conf.menus")         -- rofi rules + menu binds
require("conf.status_bar")    -- waybar layer rule + toggle bind
require("conf.wallpaper")     -- awww daemon + picker
require("conf.clipboard")     -- cliphist daemons + bind
require("conf.cursor")        -- cursor theme on start
require("conf.rgb")           -- openrgb server + profile script
require("conf.autostart")     -- waybar / polkit / hypridle
require("conf.keymaps")       -- main keybindings

--------------------
---- PERMISSIONS ---
--------------------
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Restart-only changes; left disabled by default.
--
-- hl.config({ ecosystem = { enforce_permissions = true } })
-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")
