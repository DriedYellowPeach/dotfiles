#!/usr/bin/env bash
green='\033[0;32m'
red='\033[0;31m'
cyan='\033[0;36m'
reset="\033[0m"

print_help () {
    echo -e "Usage: ./change_avatar.sh ${cyan}<username> <path_to_image>${reset}"
}
if [ "$#" -ne 2 ]; then
    print_help
    exit
fi

USERNAME="$1"
IMAGE="$2"

if ! id "$USERNAME" >/dev/null 2>&1; then
    echo -e "${red}User '$USERNAME' not found!${reset}"
    print_help
    exit
fi

if [[ ! -f "$IMAGE" ]]; then
    echo -e "${red}Invalid image file!${reset}"
    print_help
    exit
fi

AVATAR_DIR="/usr/share/icons/$USERNAME"
AVATAR_PATH="$AVATAR_DIR/$USERNAME.face.icon"

# Create directory if it doesn't exist
if [[ ! -d "$AVATAR_DIR" ]]; then
    echo -e "${green}Creating directory '$AVATAR_DIR'${reset}"
    sudo mkdir -p "$AVATAR_DIR"
fi

if [[ -f "$AVATAR_PATH" ]]; then
    echo -e "${green}Creating backup for '$AVATAR_PATH'${reset}"
    sudo cp -f "$AVATAR_PATH" "$AVATAR_PATH.bkp"
fi

sudo cp "$IMAGE" "$AVATAR_DIR/tmp_face"
# Crop image to square:
sudo mogrify -gravity center -crop 1:1 +repage "$AVATAR_DIR/tmp_face"
# Resize face to 256x256:
sudo mogrify -resize 256x256 "$AVATAR_DIR/tmp_face"
# Convert to PNG (required for SDDM/Qt compatibility):
sudo magick "$AVATAR_DIR/tmp_face" "$AVATAR_DIR/tmp_face.png"
sudo rm -f "$AVATAR_DIR/tmp_face"
sudo mv "$AVATAR_DIR/tmp_face.png" "$AVATAR_PATH"

echo -e "\n${green}Avatar updated for user '$USERNAME'!${reset}"
echo -e "${cyan}Avatar saved to: $AVATAR_PATH${reset}"
