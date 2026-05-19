-- Environment variables.
-- See https://wiki.hypr.land/Nvidia/

local v = require("conf.variables")

hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

-- Wallpaper-related env (was in wallpaper.conf)
hl.env("USER_WALLPAPER_DIR",       v.home .. "/Pictures/wallpapers")
hl.env("USER_WALLPAPER_CACHE_DIR", v.home .. "/.cache/wallpaper-thumbs")
hl.env("USER_CURRENT_WALLPAPER",   v.home .. "/.config/hypr/.current_wallpaper")
