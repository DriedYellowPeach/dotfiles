-- Environment variables.
-- See https://wiki.hypr.land/Nvidia/

local v = require("conf.variables")

hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

-- Route Qt apps through qt6ct/qt5ct so they pick up its dark theme.
-- Strawberry and most current Qt apps are Qt6 -> need qt6ct (qt5ct only themes Qt5 apps).
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- Wallpaper-related env (was in wallpaper.conf)
hl.env("USER_WALLPAPER_DIR",       v.home .. "/Pictures/wallpapers")
hl.env("USER_WALLPAPER_CACHE_DIR", v.home .. "/.cache/wallpaper-thumbs")
hl.env("USER_CURRENT_WALLPAPER",   v.home .. "/.config/hypr/.current_wallpaper")
