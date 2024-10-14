#!/usr/bin/env bash

flatpak_apps=(

  # Communication
#  'org.signal.Signal'         # Private messenger, mobile
  # 'org.videolan.VLC'          # Media player TODO: <<<<< TO UNCOMMENT

  # Creativity
# 'com.ultimaker.cura'        # 3D slicing
#  'com.obsproject.Studio'     # Video streaming
  # 'com.jgraph.drawio.desktop' # UML + Diagram tool TODO: <<<<< TO UNCOMMENT
  'com.uploadedlobster.peek'  # Screen recorder
  'fr.handbrake.ghb'          # Video transcoder
  'nl.hjdskes.gcolor3'        # Color picker
#  'org.darktable.Darktable'   # Video editor
# 'org.flameshot.Flameshot'   # Screenshot tool
  #'org.gimp.GIMP'             # Picture editor TODO: <<<<< TO UNCOMMENT
  # 'org.shotcut.Shotcut'       # Video editor TODO: <<<<< TO UNCOMMENT
  
  # Software development
  'com.visualstudio.code'     # Extendable IDE
  #'com.getpostman.Postman'    # API development TODO: <<<<< TO UNCOMMENT
  #'cc.arduino.IDE2'           # IOT development TODO: <<<<< TO UNCOMMENT
  # 'com.axosoft.GitKraken'     # GUI git client  TODO: <<<<< TO UNCOMMENT
  #'com.google.AndroidStudio'  # Android dev IDE TODO: <<<<< TO UNCOMMENT
  'io.podman_desktop.PodmanDesktop' # Docker / Podman UI
  #'flathub org.gnome.GHex'    # Hex and binary inspector TODO: <<<<< TO UNCOMMENT
  
  # Settings and system utils
  'org.bleachbit.BleachBit'   # Disk cleaner and log remover
  'it.mijorus.smile'            # Emoji picker
  # Security testing
 'org.wireshark.Wireshark'   # Packet capture and analyzer
 'org.zaproxy.ZAP'           # Auto vulnerability scanning
 'org.nmap.Zenmap'           # GUI for Nmap security scans

  # Browsers and internet
#  'org.mozilla.firefox'       # Firefox web browser (primary)
#  'com.github.Eloston.UngoogledChromium' # Chromium-based borwser (secondary)
#  'com.github.micahflee.torbrowser-launcher' # Tor browser  
)

dashbar_apps=(
  'com.visualstudio.code.desktop' # to replace by flatpak package  
)

# Color Variables
CYAN_B='\033[1;96m'
YELLOW='\033[0;93m'
RED_B='\033[1;31m'
RESET='\033[0m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
LIGHT='\x1b[2m'

# Options
PROMPT_TIMEOUT=15 # When user is prompted for input, skip after x seconds
PARAMS=$* # User-specified parameters

if [[ $PARAMS == *"--auto-yes"* ]]; then
  PROMPT_TIMEOUT=1
  AUTO_YES=true
fi

# Helper function to install Flatpak (if not present) for users current distro
function install_flatpak () {
  # Arch, Manjaro
  if hash "pacman" 2> /dev/null; then
    echo -e "${PURPLE}Installing Flatpak via Pacman${RESET}"
    sudo pacman -S flatpak
  # Debian, Ubuntu, PopOS, Raspian
  elif hash "apt" 2> /dev/null; then
    echo -e "${PURPLE}Installing Flatpak via apt get${RESET}"
    sudo apt install flatpak -y
  # Alpine
  elif hash "apk" 2> /dev/null; then
    echo -e "${PURPLE}Installing Flatpak via apk add${RESET}"
    sudo apk add flatpak
  # Red Hat, CentOS
  elif hash "yum" 2> /dev/null; then
    echo -e "${PURPLE}Installing Flatpak via Yum${RESET}"
    sudo yum install flatpak
  fi
}

# Checks if a given app ($1) is already installed, otherwise installs it
function install_app () {
  app=$1

  # If --prompt-before-each is set, then ask user if they'd like to proceed
  if [[ $PARAMS == *"--prompt-before-each"* ]]; then
    echo -e -n "\n${CYAN_B}Would you like to install ${app}? (y/N) ${RESET}"
    read -t 15 -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]] && [[ $AUTO_YES != true ]] ; then
      echo -e "\n${YELLOW}[Skipping] ${LIGHT}${app}, rejected by user${RESET}"
      return
    fi
    echo
  fi

  # Process app ID, and grep for it in system
  app_name=$(echo $app | rev | cut -d "." -f1 | rev)
  is_in_flatpak=$(echo $(flatpak list --columns=ref | grep $app))
  is_in_pacman=$(echo $(pacman -Qk $(echo $app_name | tr 'A-Z' 'a-z') 2> /dev/null ))
  is_in_apt=$(echo $(dpkg -s $(echo $app_name | tr 'A-Z' 'a-z') 2> /dev/null ))

  # Check app not already installed via Flatpak
  if [ -n "$is_in_flatpak" ]; then
    echo -e "${YELLOW}[Skipping] ${LIGHT}${app_name} is already installed.${RESET}"
  # Check app not installed via Pacman (Arch Linux)
  elif [[ "${is_in_pacman}" == *"total files"* ]]; then
    echo -e "${YELLOW}[Skipping] ${LIGHT}${app_name} is already installed via Pacman.${RESET}"
  # Check app not installed via apt get (Debian)
  elif [[ "${is_in_apt}" == *"install ok installed"* ]]; then
    echo -e "${YELLOW}[Skipping] ${LIGHT}${app_name} is already installed via apt-get.${RESET}"
  else
    # Install app using Flatpak
    echo -e "${GREEN}[Installing] ${LIGHT}Downloading ${app_name} (from ${flatpak_origin}).${RESET}"
    if [[ $PARAMS == *"--dry-run"* ]]; then return; fi # Skip if --dry-run enabled
    sudo flatpak install -y --noninteractive $flatpak_origin $app
  fi
}

function print_usage () {
  echo -e "${CYAN_B}Flatpak Linux Desktop App Installation and Update script${RESET}"
  echo -e "${PURPLE}The following tasks will be completed:\n"\
  "- Check Flatpak is installed correctly / prompt to install if not\n"\
  "- Add the flathub repo, if not already present\n"\
  "- Upgrade Flatpak, and update all exiting installed apps\n"\
  "- Installs each app in the list (if not already present)\n"\
  "${RESET}"
}

# Show help menu
print_usage
if [[ $PARAMS == *"--help"* ]]; then exit; fi

# Ask user if they'd like to proceed, and exit if not
echo -e "${CYAN_B}Would you like to install Flatpak desktop apps? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]] && [[ $AUTO_YES != true ]] ; then
  echo -e "${YELLOW}Skipping Flatpak installations..."
  exit 0
fi

echo -e "${CYAN_B}Starting Flatpak App Installation Script${RESET}"

# Check that Flatpak is present, prompt to install or exit if not
if ! hash flatpak 2> /dev/null; then
  echo -e "${PURPLE}Flatpak isn't yet installed on your system${RESET}"
  echo -e "${CYAN_B}Would you like to install Flatpak now?${RESET}\n"
  read -t $PROMPT_TIMEOUT -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]] || [[ $AUTO_YES = true ]] ; then
    install_flatpak
  else
    echo -e "${YELLOW}Skipping Flatpak installations, as Flatpack not installed"
    exit 0
  fi
fi

# Add FlatHub as upstream repo, if not already present
echo -e "${PURPLE}Adding Flathub repo${RESET}"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Update currently installed apps
echo -e "${PURPLE}Updating installed apps${RESET}"
flatpak update --assumeyes --noninteractive

# Install each app listed above (if not already installed)
echo -e "${PURPLE}Installing apps defined in manifest${RESET}"
for app in ${flatpak_apps[@]}; do
  install_app $app
done

# fixing vscode permissions
echo -e "${PURPLE}fixing vscode permissions for fonts${RESET}"
flatpak override com.visualstudio.code --filesystem=~/.local/share/fonts:ro

echo -e "${CYAN_B}Would you like to install shortcut for ADVANCED flatpak app? (y/N)${RESET}\n"
# read -t $PROMPT_TIMEOUT -n 1 -r
# echo
# if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${PURPLE}Starting creating shortcut...${RESET}"
  CURRENT_DASH=$(gsettings get org.gnome.shell favorite-apps)
  echo -e "CURRENT DASH :${CURRENT_DASH}:"
  for app in ${dashbar_apps[@]}; do
    echo -e "APP :${app}:"
    if grep -q "${app}" <<< "$CURRENT_DASH"; then
      echo -e "${YELLOW}[Skipping]${LIGHT} ${app} shortcut already exist${RESET}"
    else
      echo -e "${PURPLE}[Installing]${LIGHT} shortcut for ${app}...${RESET}"
      gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed s/.$//), '${app}']"
    fi
  done
# fi

echo -e "${PURPLE}Finished processing Flatpak apps${RESET}"
