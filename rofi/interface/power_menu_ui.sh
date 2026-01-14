#!/usr/bin/env bash

# Rofi Power Menu Launcher
# Centralized script for launching power menu from anywhere

ROFI_DIR="$HOME/.config/rofi"

# Kill existing rofi instance or launch power menu
pkill rofi || rofi -show powermenu \
	-modi "powermenu:$ROFI_DIR/scripts/build_power_menu.sh --no-text" \
	-theme "$ROFI_DIR/themes/power_theme.rasi"
