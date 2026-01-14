#!/usr/bin/env bash

# Rofi Window Menu Launcher
# Centralized script for launching window switcher from anywhere

ROFI_DIR="$HOME/.config/rofi"

# Kill existing rofi instance or launch window menu
pkill rofi || rofi -show window -window-thumbnail -config "$ROFI_DIR/window_menu.rasi"
