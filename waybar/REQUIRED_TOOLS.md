# Required Tools for Waybar Configuration

This document lists the tools needed for full functionality of the waybar configuration.

## Required Packages

### Core (Must Install)

- `waybar` - The status bar itself
- `otf-font-awesome` or `ttf-font-awesome` - Icon font support
- `ttf-jetbrains-mono-nerd` or `ttf-nerd-fonts-symbols` - Nerd font for icons (pacman ghosts, etc.)

### Audio

- `pavucontrol` - PulseAudio volume control GUI (right-click on volume)
- `pamixer` - CLI tool for volume control (scroll and click actions)

### System

- `gnome-system-monitor` - System monitor (right-click on CPU)

### Power Management

- `wlogout` - Logout/power menu (click on power icon)

### Application Launcher

- `rofi` - Application launcher (click on logo)

## Installation (Arch Linux)

```bash
# Core packages
sudo pacman -S waybar otf-font-awesome

# Install nerd fonts (choose one)
sudo pacman -S ttf-jetbrains-mono-nerd
# OR from AUR: yay -S nerd-fonts-jetbrains-mono

# Audio tools
sudo pacman -S pavucontrol pamixer

# System tools
sudo pacman -S gnome-system-monitor

# Power menu
sudo pacman -S wlogout

# Application launcher
sudo pacman -S rofi
```

## Quick Install (All at Once)

```bash
sudo pacman -S waybar otf-font-awesome ttf-jetbrains-mono-nerd pavucontrol pamixer gnome-system-monitor wlogout rofi
```

## Optional Enhancements

- `playerctl` - Media player controls (if you add mpris module)
- `blueman` - Bluetooth manager (if you add bluetooth module)
- `networkmanager` / `network-manager-applet` - For network management
- `brightnessctl` - Screen brightness control (if you add backlight module)

## Applying Changes

After installing the required packages, restart waybar:

```bash
killall waybar && waybar &
```

Or reload Hyprland config if waybar is managed by Hyprland:

```bash
hyprctl reload
```
