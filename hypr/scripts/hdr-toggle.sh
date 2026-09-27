#!/bin/bash

# Toggle HDR on the primary monitor (DP-3).
#
# The state lives in a file that conf/monitors.lua reads at config time, so a
# plain `hyprctl reload` (or a fresh login) keeps whatever was last chosen
# instead of snapping back. Hyprland never resets a monitor key you omit, so
# monitors.lua always writes the full HDR *and* SDR key set -- see the comment
# there before changing this.
#
# Usage: hdr_toggle [on|off|toggle|status]   (default: toggle)

set -eu

STATE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/hypr/hdr"

read_state() {
    if [ -r "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" = "on" ]; then
        echo on
    else
        echo off
    fi
}

notify() {
    command -v hyprctl >/dev/null 2>&1 && hyprctl notify -1 2000 0 "HDR: $1" >/dev/null 2>&1 || true
}

apply() {
    mkdir -p "$(dirname "$STATE_FILE")"
    printf '%s\n' "$1" > "$STATE_FILE"
    hyprctl reload >/dev/null
    echo "HDR $1"
    notify "$1"
}

current=$(read_state)

case "${1:-toggle}" in
    on)     apply on ;;
    off)    apply off ;;
    toggle) if [ "$current" = "on" ]; then apply off; else apply on; fi ;;
    status) echo "$current" ;;
    *)      echo "usage: ${0##*/} [on|off|toggle|status]" >&2; exit 1 ;;
esac
