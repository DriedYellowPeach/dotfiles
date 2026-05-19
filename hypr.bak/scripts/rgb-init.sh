#!/bin/sh

# Initialize RGB profile on login
# Waits for OpenRGB server to be ready before loading profile

CONFIG="/home/neil/.config/OpenRGB"
PROFILE="us"

# Wait for OpenRGB server to be ready (up to 10 seconds)
for _ in 1 2 3 4 5 6 7 8 9 10; do
	if timeout 2 openrgb --client --list-devices >/dev/null 2>&1; then
		break
	fi
	sleep 1
done

openrgb --config "$CONFIG" --profile "$PROFILE"
