#!/usr/bin/env bash

# Wallpaper Picker Script
# Uses awww to set wallpapers with rofi preview

# Toggle: if rofi is running, kill it and exit
if pkill rofi; then
	exit 0
fi

set -e
set -u

# Use environment variables or defaults
WALLPAPER_DIR="${USER_WALLPAPER_DIR:-$HOME/Pictures/wallpapers}"
CACHE_DIR="${USER_WALLPAPER_CACHE_DIR:-$HOME/.cache/wallpaper-thumbs}"
CURRENT_WALLPAPER_LINK="${USER_CURRENT_WALLPAPER:-$HOME/.config/hypr/.current_wallpaper}"

# awww transition settings
TRANSITION_TYPE="grow"
TRANSITION_POS="center"
TRANSITION_DURATION="1"
TRANSITION_FPS="60"

# Function to get thumbnail from cache (no generation)
get_thumbnail() {
	local img="$1"
	local name
	name=$(basename "$img")
	local thumb="$CACHE_DIR/${name%.*}.png"

	if [[ -f "$thumb" ]]; then
		echo "$thumb"
	else
		# Fallback to original image if no cached thumbnail
		echo "$img"
	fi
}

# Function to update current wallpaper symlink
update_wallpaper_link() {
	local wallpaper="$1"
	ln -sf "$wallpaper" "$CURRENT_WALLPAPER_LINK"
}

# Function to get current wallpaper
get_current() {
	awww query 2>/dev/null | head -1 | grep -oP 'image: \K.*' || echo ""
}

# Check if wallpaper directory exists
if [[ ! -d "$WALLPAPER_DIR" ]]; then
	notify-send "Wallpaper Picker" "Directory not found: $WALLPAPER_DIR"
	exit 1
fi

# Find all wallpapers
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" \) | sort)

if [[ ${#WALLPAPERS[@]} -eq 0 ]]; then
	notify-send "Wallpaper Picker" "No wallpapers found in $WALLPAPER_DIR"
	exit 1
fi

# Get current wallpaper for marking
CURRENT=$(get_current)

# Build rofi menu
build_menu() {
	for wall in "${WALLPAPERS[@]}"; do
		local name
		name=$(basename "$wall")
		local thumb
		thumb=$(get_thumbnail "$wall")

		# Mark current wallpaper
		if [[ "$wall" == "$CURRENT" ]]; then
			name="* $name"
		fi

		printf "%s\0icon\x1f%s\x1finfo\x1f%s\n" "$name" "$thumb" "$wall"
	done
}

# Show rofi picker
choice=$(build_menu | rofi -dmenu -i -p "Wallpaper" \
	-config ~/.config/rofi/wallpaper_menu.rasi \
	-show-icons)

# Exit if no selection
[[ -z "$choice" ]] && exit 0

# Get the selected wallpaper path from ROFI_INFO
selected="${ROFI_INFO:-}"

# If ROFI_INFO is empty, find the wallpaper by name
if [[ -z "$selected" ]]; then
	# Remove the marker if present
	choice="${choice#\* }"
	for wall in "${WALLPAPERS[@]}"; do
		if [[ "$(basename "$wall")" == "$choice" ]]; then
			selected="$wall"
			break
		fi
	done
fi

# Apply wallpaper if found
if [[ -n "$selected" && -f "$selected" ]]; then
	awww img "$selected" \
		--transition-type "$TRANSITION_TYPE" \
		--transition-pos "$TRANSITION_POS" \
		--transition-duration "$TRANSITION_DURATION" \
		--transition-fps "$TRANSITION_FPS"

	# Update symlink for hyprlock
	update_wallpaper_link "$selected"

	notify-send -i "$selected" "Wallpaper" "$(basename "$selected")"
fi
