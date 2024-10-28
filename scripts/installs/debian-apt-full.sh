#!/usr/bin/env bash

debian_apps=(
  # more
  'remmina'
  'remmina-plugin*'

  # Virtual machine
  'qemu-kvm'
  'virt-manager'
  'virtinst'
  'libvirt-clients'
  'bridge-utils'
  'libvirt-daemon-system'

  # for remotebox
  'libgtk3-perl'
  'libsoap-lite-perl'
  'freerdp2-x11'
  'tigervnc-viewer'

  # docker
  'docker-ce'
  'docker-ce-cli'
  'containerd.io'
  'docker-buildx-plugin'
  'docker-compose-plugin'

  # creativity
  )

dashbar_apps=(
  'org.remmina.Remmina.desktop'
  'virt-manager.desktop' 
  'remotebox32.desktop'
  'remotebox33.desktop'
)

# Colors
PURPLE='\033[0;35m'
YELLOW='\033[0;93m'
CYAN_B='\033[1;96m'
LIGHT='\x1b[2m'
RESET='\033[0m'

PROMPT_TIMEOUT=15 # When user is prompted for input, skip after x seconds

# If set to auto-yes - then don't wait for user reply
if [[ $* == *"--auto-yes"* ]]; then
  PROMPT_TIMEOUT=0
  REPLY='Y'
fi

# Print intro message
echo -e "${PURPLE}Starting Debian/ Ubuntu package for more app to install"
echo -e "${YELLOW}Before proceeding, ensure your happy with all the packages listed in \e[4m${0##*/}"
echo -e "${RESET}"

# Check if running as root, and prompt for password if not
if [ "$EUID" -ne 0 ]; then
  echo -e "${PURPLE}Elevated permissions are required to adjust system settings."
  echo -e "${CYAN_B}Please enter your password...${RESET}"
  sudo -v
  if [ $? -eq 1 ]; then
    echo -e "${YELLOW}Exiting, as not being run as sudo${RESET}"
    exit 1
  fi
fi

# Check apt-get actually installed
if ! hash apt 2> /dev/null; then
  echo "${YELLOW_B}apt doesn't seem to be present on your system. Exiting...${RESET}"
  exit 1
fi



# Prompt user to install all listed apps
echo -e "${CYAN_B}Would you like to install listed apps? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${PURPLE}Starting install...${RESET}"
  for app in ${debian_apps[@]}; do
    if hash "${app}" 2> /dev/null; then
      echo -e "${YELLOW}[Skipping]${LIGHT} ${app} is already installed${RESET}"
    elif hash flatpak 2> /dev/null && [[ ! -z $(echo $(flatpak list --columns=ref | grep $app)) ]]; then
      echo -e "${YELLOW}[Skipping]${LIGHT} ${app} is already installed via Flatpak${RESET}"
    else
      echo -e "${PURPLE}[Installing]${LIGHT} Downloading ${app}...${RESET}"
      sudo apt install ${app} --assume-yes
    fi
  done
fi

sudo systemctl start libvirtd
sudo usermod -aG libvirt $USER

# install remotebox 3.2 and 3.3
echo -e "${CYAN_B}Would you like to install GITUI? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  REMOTEBOX33="https://remotebox.knobgoblin.org.uk/downloads/RemoteBox-3.3.tar.bz2"
  REMOTEBOX32="https://remotebox.knobgoblin.org.uk/downloads/RemoteBox-3.2.tar.bz2"
  # 3.3
  echo $REMOTEBOX33 | /bin/wget -O ~/Downloads/RemoteBox-3.3.tar.bz2 -qi -
  /bin/tar xf ~/Downloads/RemoteBox-3.3.tar.bz2
  /bin/sudo /bin/rm -Rf /usr/local/bin/RemoteBox-3.3
  /bin/sudo /bin/mv -f RemoteBox-3.3 /usr/local/bin/
  /bin/rm ~/Downloads/RemoteBox-3.3.tar.bz2
  /bin/rm RemoteBox-3.3 2> /dev/null
  sudo tee /usr/share/applications/remotebox33.desktop > /dev/null <<'EOF'
[Desktop Entry]
Version=3.3
Type=Application
Name=RemoteBox33
Comment=Manage virtualbox headless server for vbox 7.1
Icon=/usr/local/bin/RemoteBox-3.3/share/remotebox/icons/remotebox.png
OnlyShowIn=Budgie;Cinnamon;GNOME;KDE;LXDE;LXQt;MATE;Pantheon;Unity;XFCE;
Exec=/usr/local/bin/RemoteBox-3.3/remotebox
Categories=GNOME;GTK;Settings;DesktopSettings;Utility;
Keywords=Configuration;vbox;virtualbox;
StartupNotify=true
Terminal=false
X-Ubuntu-Gettext-Domain=RemoteBox33

EOF
  sudo chmod +x /usr/share/applications/remotebox33.desktop

  # 3.2
  echo $REMOTEBOX32 | /bin/wget -O ~/Downloads/RemoteBox-3.2.tar.bz2 -qi -
  /bin/tar xf ~/Downloads/RemoteBox-3.2.tar.bz2
  /bin/sudo /bin/rm -Rf /usr/local/bin/RemoteBox-3.2
  /bin/sudo /bin/mv -f RemoteBox-3.2 /usr/local/bin/
  /bin/rm ~/Downloads/RemoteBox-3.2.tar.bz2
  /bin/rm RemoteBox-3.2 2> /dev/null
  sudo tee /usr/share/applications/remotebox32.desktop > /dev/null <<'EOF'
[Desktop Entry]
Version=3.2
Type=Application
Name=RemoteBox32
Comment=Manage virtualbox headless server for vbox 7.0
Icon=/usr/local/bin/RemoteBox-3.2/share/remotebox/icons/remotebox.png
OnlyShowIn=Budgie;Cinnamon;GNOME;KDE;LXDE;LXQt;MATE;Pantheon;Unity;XFCE;
Exec=/usr/local/bin/RemoteBox-3.2/remotebox
Categories=GNOME;GTK;Settings;DesktopSettings;Utility;
Keywords=Configuration;vbox;virtualbox;
StartupNotify=true
Terminal=false
X-Ubuntu-Gettext-Domain=RemoteBox32

EOF
  sudo chmod +x /usr/share/applications/remotebox32.desktop

fi

echo -e "${CYAN_B}Would you like to install shortcut for for advanced APT app? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
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
fi

echo -e "${PURPLE}Finished installing / updating Debian packages.${RESET}"

# EOF