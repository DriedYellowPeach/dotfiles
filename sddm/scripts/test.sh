#!/usr/bin/env bash
green='\033[0;32m'
red='\033[0;31m'
bred='\033[1;31m'
cyan='\033[0;36m'
grey='\033[2;37m'
reset="\033[0m"

# Test for debug param ( debug | -debug | -d | --debug )
# Compensate for Hyprland monitor scale (1.33) so test matches real SDDM
# Theme now uses scale=1.33, so we need to cancel out Hyprland's 1.33 scaling
export QT_SCALE_FACTOR=0.75
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_IM_MODULE=qtvirtualkeyboard
export QML2_IMPORT_PATH=./components/

if [[ "$1" =~ ^(debug|-debug|--debug|-d)$ ]]; then
    sddm-greeter-qt6 --test-mode --theme .
else
    config_file=$(awk -F '=' '/^ConfigFile=/ {print $2}' metadata.desktop)
    echo -e "${green}Testing Silent theme...${reset}\nLoading config: ${config_file}\nDon't worry about the infinite loading, SDDM won't let you log in while in 'test-mode'."
    sddm-greeter-qt6 --test-mode --theme . > /dev/null 2>&1
fi

if [ ! -d "/usr/share/sddm/themes/silent" ]; then
    echo -e "\n${bred}[WARNING]: ${red}theme not installed!${reset}"
    echo -e "Run ${cyan}'./install.sh'${reset} or copy the contents of the theme to ${cyan}'/usr/share/sddm/themes/silent/'${reset} and set the current theme to ${cyan}'silent'${reset} in ${cyan}'/etc/sddm.conf'${reset}:\n"
    echo -e "    ${grey}# /etc/sddm.conf${reset}"
    echo -e "    [Theme]"
    echo -e "    Current=silent"
fi
