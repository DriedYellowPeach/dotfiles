-- Shared variables. require() returns this table; other modules read fields.
local home = os.getenv("HOME")
return {
	mainMod = "SUPER",
	terminal = "kitty",
	fileManager = "nautilus",
	status_bar = "waybar",
	music_player = "strawberry",

	home = home,
	rofi_ui_dir = home .. "/.config/rofi/interface",
	hypr_dir = home .. "/.config/hypr",
}
