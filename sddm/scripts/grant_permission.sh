#!/bin/bash

# Grant SDDM access to user wallpaper files via ACL
# This allows SDDM to follow symlinks to wallpapers in your home directory

set -e

USER_HOME="$HOME"
WALLPAPER_DIR="$USER_HOME/Pictures/wallpapers"
HYPR_CONFIG="$USER_HOME/.config/hypr"

echo "Granting sddm access to wallpaper paths..."

# Grant traverse (execute) permission on directory path
sudo setfacl -m u:sddm:x "$USER_HOME"
sudo setfacl -m u:sddm:x "$USER_HOME/.config"
sudo setfacl -m u:sddm:x "$HYPR_CONFIG"
sudo setfacl -m u:sddm:x "$USER_HOME/Pictures"
sudo setfacl -m u:sddm:x "$WALLPAPER_DIR"

# Grant read permission on the symlink and wallpapers
sudo setfacl -m u:sddm:r "$HYPR_CONFIG/.current_wallpaper"
sudo setfacl -R -m u:sddm:rX "$WALLPAPER_DIR"

echo "Done. Verifying permissions:"
getfacl "$USER_HOME" | grep sddm || echo "  (none on $USER_HOME)"
getfacl "$WALLPAPER_DIR" | grep sddm || echo "  (none on $WALLPAPER_DIR)"

echo ""
echo "SDDM should now be able to access your wallpapers."
