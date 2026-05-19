#!/bin/bash

# Hyprland preflight script - install dependencies

set -e

ICONS_DIR="$HOME/.local/share/icons"
CURSOR_NAME="Bibata-Modern-Ice"
CURSOR_URL="https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Modern-Ice.tar.xz"

install_bibata_cursor() {
    if [ -d "$ICONS_DIR/$CURSOR_NAME" ]; then
        echo "Bibata cursor already installed, skipping..."
        return 0
    fi

    echo "Installing Bibata-Modern-Ice cursor..."

    mkdir -p "$ICONS_DIR"

    TMP_FILE=$(mktemp --suffix=.tar.xz)

    echo "Downloading from GitHub..."
    curl -L -o "$TMP_FILE" "$CURSOR_URL"

    echo "Extracting to $ICONS_DIR..."
    tar -xf "$TMP_FILE" -C "$ICONS_DIR"

    rm -f "$TMP_FILE"

    echo "Bibata cursor installed successfully!"
}

main() {
    echo "Running Hyprland preflight..."
    install_bibata_cursor
    echo "Preflight complete!"
}

main "$@"
