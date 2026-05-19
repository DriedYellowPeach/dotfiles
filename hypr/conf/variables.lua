-- Shared variables. require() returns this table; other modules read fields.
local home = os.getenv("HOME")
return {
  mainMod      = "SUPER",
  terminal     = "alacritty",
  fileManager  = "nautilus",
  status_bar   = "waybar",

  home         = home,
  rofi_ui_dir  = home .. "/.config/rofi/interface",
  hypr_dir     = home .. "/.config/hypr",
}
