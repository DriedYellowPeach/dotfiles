#!/usr/bin/env bash

# Rofi Clipboard Menu Launcher
# Centralized script for launching clipboard history from anywhere

ROFI_DIR="$HOME/.config/rofi"

# Kill existing rofi instance or launch clipboard menu
# Format: "1\tcontent" -> "1) content"
pkill rofi || cliphist list | sed 's/\t/) /' | rofi -dmenu -p "Clipboard" -config "$ROFI_DIR/clipboard_menu.rasi" | sed 's/) /\t/' | cliphist decode | wl-copy
