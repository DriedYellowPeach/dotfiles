#!/usr/bin/env bash

# Rofi App Menu Launcher
# Centralized script for launching app menu from anywhere

ROFI_DIR="$HOME/.config/rofi"

# Kill existing rofi instance or launch app menu
pkill rofi || rofi -show drun -config "$ROFI_DIR/app_menu.rasi"
