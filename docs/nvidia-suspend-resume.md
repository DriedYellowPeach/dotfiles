# NVIDIA Suspend/Resume Issue

- Date: 2026-01-30
- GPU: NVIDIA GeForce RTX 5090
- Driver: 590.48.01
- Session: Wayland/Hyprland

## Problem

Screen takes a long time (~13+ seconds) to light up after resume from suspend.

Kernel logs show multiple flip event timeouts:

```
[drm:nv_drm_atomic_commit [nvidia_drm]] *ERROR* [nvidia-drm] [GPU ID 0x00000100] Flip event timeout on head 0
[drm:nv_drm_atomic_commit [nvidia_drm]] *ERROR* [nvidia-drm] [GPU ID 0x00000100] Flip event timeout on head 1
```

Each timeout takes ~3 seconds, occurring on both monitor heads multiple times.

## Current Configuration

- `nvidia-suspend.service`, `nvidia-resume.service`, `nvidia-hibernate.service` are enabled
- `PreserveVideoMemoryAllocations=1` was tested but did not help

## Potential Workarounds (Not Yet Tested)

### 1. Disable fbdev

Add to `/etc/modprobe.d/nvidia.conf`:

```
options nvidia-drm fbdev=0
```

### 2. Disable GPU firmware

Add to `/etc/modprobe.d/nvidia.conf`:

```
options nvidia NVreg_EnableGpuFirmware=0
```

### 3. Combined

```
options nvidia NVreg_EnableGpuFirmware=0
options nvidia-drm modeset=1 fbdev=0
```

After any change, rebuild initramfs:

```bash
sudo mkinitcpio -P
```

## Analysis (2026-01-30)

### Resume Timeline

From journal logs with monotonic timestamps:

```
1938.944s - PM: suspend exit (kernel wakes up)
1939.904s - nvidia-resume.service finishes
1943.213s - Flip event timeout on head 0  (+3.3s)
1946.221s - Flip event timeout on head 1  (+3s)
1949.229s - Flip event timeout on head 0  (+3s)
1952.237s - Flip event timeout on head 1  (+3s)
1955.945s - Hyprland finally starts
```

Total delay: ~17 seconds from suspend exit to display ready.

### Root Cause

The `nvidia-sleep.sh` script (called by nvidia-resume.service) writes "resume" to `/proc/driver/nvidia/suspend` and immediately tries to restore the VT. The GPU is not fully ready when the DRM subsystem tries to perform atomic commits, causing ~3 second timeouts per display head.

### Solution: Add Delay to nvidia-resume.service

Create a systemd override:

```bash
sudo systemctl edit nvidia-resume.service
```

Add:

```ini
[Service]
ExecStartPost=/bin/sleep 2
```

This adds a 2-second delay after nvidia-resume completes, giving the GPU more time to initialize before systemd continues and Hyprland tries to render.

### Alternative: hypridle after_sleep_cmd

In `~/.config/hypr/hypridle.conf`, uncomment/add:

```conf
after_sleep_cmd = sleep 2 && hyprctl dispatch dpms on
```

This won't prevent the flip timeouts but may help Hyprland recover faster.

### Services Status

Enabled NVIDIA services:

- nvidia-suspend.service
- nvidia-resume.service
- nvidia-hibernate.service
- nvidia-suspend-then-hibernate.service
- nvidia-persistenced.service
- nvidia-powerd.service (can try disabling)

## Status

Unresolved - likely a driver bug with RTX 5090 / 590.x driver on Wayland.

## Diagnostic Commands

Check suspend/resume timing:

```bash
journalctl -b 0 -o short-monotonic | grep -E "PM: (suspend|resume)"
```

Check NVIDIA flip timeouts:

```bash
journalctl -b 0 | grep -i "flip event timeout"
```

Detailed resume logs (adjust timestamp range as needed):

```bash
journalctl -b 0 -o short-monotonic | grep -E "^\[[ ]*193[89]\."
```

## References

- [NVIDIA Forums: Flip event timeout on Wayland](https://forums.developer.nvidia.com/t/545-29-06-18-1-flip-event-timeout-error-on-startup-shutdown-and-sometimes-suspend-wayland-unusable/274788)
- [Arch Linux Forums: nvidia-suspend failing on Wayland](https://bbs.archlinux.org/viewtopic.php?id=274043)
- [NVIDIA Forums: Screen freezes with Flip event timeout](https://forums.developer.nvidia.com/t/screen-freezes-on-wayland-with-error-nvidia-drm-gpu-id-0x00002d00-flip-event-timeout-on-head-1/318959)
