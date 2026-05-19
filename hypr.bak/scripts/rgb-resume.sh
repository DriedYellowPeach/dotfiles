#!/bin/sh

# Restore RGB profile after resume
# GPU RGB needs two attempts to initialize properly

CONFIG="/home/neil/.config/OpenRGB"
PROFILE="us"

sleep 1
openrgb --config "$CONFIG" --profile "$PROFILE"
sleep 0.5
openrgb --config "$CONFIG" --profile "$PROFILE"
