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
* [3. Hyprlock Setup](#3-hyprlock-setup)
  * [3.1 Install hyprlock](#31-install-hyprlock)
  * [3.2 Configuration](#32-configuration)
  * [3.3 Keybinding](#33-keybinding)
* [4. Rofi Menus](#4-rofi-menus)
  * [4.1 Install rofi](#41-install-rofi)
  * [4.2 Configuration files](#42-configuration-files)
  * [4.3 App Launcher](#43-app-launcher)
  * [4.4 Window Switcher](#44-window-switcher)
  * [4.5 Power Menu](#45-power-menu)
  * [4.6 Hyprland Integration](#46-hyprland-integration)
* [5. Customizing sddm](#5-customizing-sddm)
  * [5.1 Dependencies](#51-dependencies)
  * [5.2 Configuration files](#52-configuration-files)
  * [5.3 Installation](#53-installation)
  * [5.4 Customization](#54-customization)
* [6. Some other tools](#6-some-other-tools)

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

**Workspace colors:**

Workspaces are color-coded by monitor in `style.css`:

| Workspaces | Monitor  | Color                    |
| ---------- | -------- | ------------------------ |
| 1-5        | HDMI-A-2 | Muted red-gray `#c07070` |
| 6-10       | DP-3     | Muted blue `#5aafd5`     |
| Active     | Any      | Yellow `#ffff00`         |

CSS selectors used:

```css
/* Workspaces 1-5 */
#workspaces button:nth-child(-n + 5) {
  color: #c07070;
}

/* Workspaces 6-10 */
#workspaces button:nth-child(n + 6) {
  color: #5aafd5;
}

/* Active workspace */
#workspaces button.active {
  color: #ffff00;
}
```

## 3. Hyprlock Setup

Hyprlock is the official lock screen for Hyprland.

### 3.1 Install hyprlock

```bash
pacman -S hyprlock
```

### 3.2 Configuration

Configuration file is located at `~/.config/hypr/hyprlock.conf`.

**Background:**

- Uses a wallpaper image with adjustable brightness and vibrancy
- Blur can be enabled with `blur_passes` (0 = no blur)

**Input Field:**

- Centered password input with custom styling
- Uses Pango markup for placeholder and fail text styling
- Example: `<span foreground="##686868" size="27pt" weight="bold">Enter Passcode</span>`

**Labels:**

- Date label: Shows day of week and date (e.g., "Monday, Jan 12")
- Time label: Shows current time in HH:MM:SS format
- Both use the Deutschlander font at 360pt size

### 3.3 Keybinding

Hyprlock is bound to `Super + L` in `~/.config/hypr/hyprland.conf`:

```
bind = $mainMod, L, exec, hyprlock
```

## 4. Rofi Menus

Rofi is used as the application launcher, window switcher, and power menu.

### 4.1 Install rofi

```bash
pacman -S rofi-wayland
```

### 4.2 Configuration files

Rofi configuration is located in `~/.config/rofi/`:

| File                         | Purpose                       |
| ---------------------------- | ----------------------------- |
| `shared.rasi`                | Shared colors and base config |
| `app_menu.rasi`              | App launcher configuration    |
| `app_theme.rasi`             | App launcher theme            |
| `window_menu.rasi`           | Window switcher configuration |
| `window_theme.rasi`          | Window switcher theme         |
| `power_theme.rasi`           | Power menu theme              |
| `scripts/rofi-power-menu.sh` | Power menu script             |

**Shared styling (`shared.rasi`):**

- Glass effect with transparency (requires Hyprland blur)
- Click outside or press Escape to close
- Hover to select items
- Uses Monaspace Krypton NF font

### 4.3 App Launcher

**Keybinding:** `Super + Space`

**Features:**

- Shows installed applications (drun mode)
- Also includes run and filebrowser modes (switchable via sidebar)
- Uses Papirus icon theme
- History enabled for frequently used apps

**Command:**

```bash
rofi -show drun -config ~/.config/rofi/app_menu.rasi
```

### 4.4 Window Switcher

**Keybinding:** `Super + Tab`

**Features:**

- Shows all open windows across workspaces
- Window thumbnails enabled
- Format: `{workspace} {class} {title}`

**Command:**

```bash
rofi -show window -window-thumbnail -config ~/.config/rofi/window_menu.rasi
```

### 4.5 Power Menu

**Keybinding:** `Super + P`

**Features:**

- Lock screen, logout, suspend, hibernate, reboot, shutdown
- Confirmation required for logout, reboot, and shutdown
- Icons-only display (no text)
- Horizontal layout with 6 columns

**Command:**

```bash
rofi -show powermenu -modi "powermenu:~/.config/rofi/scripts/rofi-power-menu.sh --no-text" -theme ~/.config/rofi/power_theme.rasi
```

**Power menu script options:**

| Option         | Description                                     |
| -------------- | ----------------------------------------------- |
| `--choices`    | Limit which actions to show (use `/` separator) |
| `--confirm`    | Which actions require confirmation              |
| `--no-symbols` | Hide icons                                      |
| `--no-text`    | Hide text labels                                |
| `--dry-run`    | Print action instead of executing               |

### 4.6 Hyprland Integration

Menu variables are defined in `~/.config/hypr/variables.conf`:

```
$menu = rofi -show drun -config ~/.config/rofi/app_menu.rasi
$powermenu = rofi -show powermenu -modi "powermenu:~/.config/rofi/scripts/rofi-power-menu.sh --no-text" -theme ~/.config/rofi/power_theme.rasi
$windowmenu = rofi -show window -window-thumbnail -config ~/.config/rofi/window_menu.rasi
```

Window and layer rules are configured in `~/.config/hypr/conf/menus.conf`:

- Float and center rofi windows
- Apply blur effect via layerrule
- Dim background when rofi is open

**Keybindings summary:**

| Keybinding      | Action          |
| --------------- | --------------- |
| `Super + Space` | App launcher    |
| `Super + Tab`   | Window switcher |
| `Super + P`     | Power menu      |

## 5. Customizing sddm

### 5.1 Dependencies

```bash
pacman -S qt6-svg qt6-virtualkeyboard qt6-multimedia
yay -S sddm-theme-silent
```

Requirements:

- SDDM >= 0.21
- QT >= 6.5

### 5.2 Configuration files

Configuration is stored in `~/.config/sddm/`:

| File              | Purpose                                   |
| ----------------- | ----------------------------------------- |
| `theme.conf`      | SilentSDDM theme customization            |
| `sddm-theme.conf` | System config (copy to /etc/sddm.conf.d/) |

### 5.3 Installation

1. Copy system config:

```bash
sudo cp ~/.config/sddm/sddm-theme.conf /etc/sddm.conf.d/theme.conf
```

2. Rename the theme directory and symlink theme.conf:

```bash
sudo mv /usr/share/sddm/themes/SilentSDDM /usr/share/sddm/themes/default
sudo ln -sf /home/neil/.config/sddm/theme.conf /usr/share/sddm/themes/default/theme.conf
```

Using a symlink allows editing `~/.config/sddm/theme.conf` directly without re-copying.

3. Set up user avatar (optional):

```bash
# Copy your avatar to the faces directory
sudo cp /path/to/your/avatar.png /var/lib/AccountsService/icons/$USER
# Or create a symlink
sudo ln -sf /path/to/your/avatar.png /var/lib/AccountsService/icons/$USER
```

### 5.4 Customization

The theme uses:

- **Background**: Same wallpaper as hyprlock (`~/.config/hypr/.current_wallpaper`)
- **Font**: JetBrainsMono Nerd Font (consistent with hyprlock)
- **Style**: Minimal white-on-dark with glass effects

Key configuration sections in `theme.conf`:

- `[LockScreen]` - Initial lock screen with clock
- `[LoginScreen]` - Login area with avatar and password input
- `[LoginScreen.MenuArea]` - Session selector, power menu, keyboard toggle

Reference: https://github.com/uiriansan/SilentSDDM/wiki/Customizing

## 6. Some other tools

- [x] setup the wallpaper, switching effect here
- [x] reset the ctrl + v keymap for alacritty, and fix clipboard
- [x] sddm customize
- [x] The margin at the bottom of waybar is too much
- [x] hyprlock can have user icon, do it
- [x] know more about workspace
- [x] File browser
- [x] window style: active window border, normal window border

- to take screenshot
- how to set hypridle
- waybar detailed info better
- for the logo, show some neofetch like info?
- rofi emoji menu
