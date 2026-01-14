#!/usr/bin/env bash

# Build Wallpaper Thumbnail Cache
# Cleans old cache and generates new thumbnails

set -e
set -u

# Use environment variables or defaults
WALLPAPER_DIR="${USER_WALLPAPER_DIR:-$HOME/Pictures/wallpapers}"
CACHE_DIR="${USER_WALLPAPER_CACHE_DIR:-$HOME/.cache/wallpaper-thumbs}"

THUMB_WIDTH=300
THUMB_HEIGHT=200

# Check dependencies
if ! command -v magick &>/dev/null && ! command -v convert &>/dev/null; then
	echo "Error: ImageMagick not found. Install with: pacman -S imagemagick"
	exit 1
fi

# Check wallpaper directory
if [[ ! -d "$WALLPAPER_DIR" ]]; then
	echo "Error: Wallpaper directory not found: $WALLPAPER_DIR"
	exit 1
fi

# Clean and recreate cache directory
echo "Cleaning cache directory: $CACHE_DIR"
rm -rf "$CACHE_DIR"
mkdir -p "$CACHE_DIR"

# Find all wallpapers
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" \) | sort)

if [[ ${#WALLPAPERS[@]} -eq 0 ]]; then
	echo "No wallpapers found in $WALLPAPER_DIR"
	exit 0
fi

echo "Found ${#WALLPAPERS[@]} wallpapers"
echo "Generating thumbnails..."

count=0
for img in "${WALLPAPERS[@]}"; do
	name=$(basename "$img")
	thumb="$CACHE_DIR/${name%.*}.png"

	if magick "$img" -thumbnail "${THUMB_WIDTH}x${THUMB_HEIGHT}^" -gravity center -extent "${THUMB_WIDTH}x${THUMB_HEIGHT}" "$thumb" 2>/dev/null ||
		convert "$img" -thumbnail "${THUMB_WIDTH}x${THUMB_HEIGHT}^" -gravity center -extent "${THUMB_WIDTH}x${THUMB_HEIGHT}" "$thumb" 2>/dev/null; then
		((count++))
		echo "  [$count/${#WALLPAPERS[@]}] $name"
	else
		echo "  [FAILED] $name"
	fi
done

echo "Done. Generated $count thumbnails in $CACHE_DIR"
