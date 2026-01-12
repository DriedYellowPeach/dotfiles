# Hyprland Setup Guide

<!-- mtoc-start -->

* [1. Setup Display Manager and Session Manager](#1-setup-display-manager-and-session-manager)
  * [1.1 Install required packages](#11-install-required-packages)
  * [1.2 Usage](#12-usage)
  * [1.3 Why `uwsm` useful?](#13-why-uwsm-useful)
  * [1.4 Customize sddm](#14-customize-sddm)
* [2. Waybar Setup](#2-waybar-setup)
  * [2.1 Install waybar](#21-install-waybar)
  * [2.2 Autostart configuration](#22-autostart-configuration)
  * [2.3 Configuration files](#23-configuration-files)
  * [2.4 Customization](#24-customization)
* [3. Some other tools](#3-some-other-tools)

<!-- mtoc-end -->

## 1. Setup Display Manager and Session Manager

So the architecture overview should look like this:

```
Display Manager
  └── systemd-logind
        └── UWSM
              └── Hyprland
```

### 1.1 Install required packages

```bash
pacman -S qt5-wayland qt6-wayland
```

- Desktop portals: these are a DBus-based permission mediation layer that allows applications to safely request access to privileged desktop resources

```bash
pacman -S xdg-desktop-portal xdg-desktop-portal-hyprland
```

- Authentication Agent

```bash
pacman -S hyprpolkitagent polkit
```

- Display Manager

```bash
pacman -S sddm
```

- Session Manager

```bash
pacman -S uwsm
```

### 1.2 Usage

So basically hyprland has predefined `hyprland-uwsm.desktop` wayland session you can choose in the sddm session selection menu

### 1.3 Why `uwsm` useful?

It seems `uwsm` will automatically make the app start by it a `systemd` unit, so we have centralized logs? Auto-restart mechanism?

### 1.4 Customize sddm

**Issues:**

- [ ] No user icon
- [ ] Themes is ugly
- [ ] Use `uwsm` to set auto-start openrgb server

## 2. Waybar Setup

Waybar is a customizable status bar for Wayland compositors.

### 2.1 Install waybar

```bash
pacman -S waybar
```

### 2.2 Autostart configuration

Waybar is configured to autostart with Hyprland via `~/.config/hypr/conf/autostart.conf`:

```
exec-once = uwsm app -- waybar
```

Using `uwsm app` ensures waybar runs as a systemd user service with proper logging and lifecycle management.

### 2.3 Configuration files

Waybar configuration is located in `~/.config/waybar/`:

- `config.jsonc` - Module configuration and layout
- `style.css` - Visual styling (Catppuccin Mocha theme)

**Modules configured:**

| Position | Modules                        |
| -------- | ------------------------------ |
| Left     | Workspaces                     |
| Center   | Clock                          |
| Right    | Tray, Volume, Network, Battery |

### 2.4 Customization

To reload waybar after config changes:

```bash
killall waybar && uwsm app -- waybar
```

Or use hyprctl:

```bash
hyprctl dispatch exec "uwsm app -- waybar"
```

## 3. Some other tools

- to lock screen: hyprlock
- to take screenshot
- better app launcher?
- waybar detailed info better
- for the logo, check package update?
- know more about workspace
