#!/usr/bin/env bash

################################################################
# 📜 Debian/ Ubuntu, apt Package Install / Update Script       #
################################################################
# Installs listed packages on Debian-based systems via apt-get #
# Also updates the cache database and existing applications    #
# Confirms apps aren't installed via different package manager #
# Doesn't include desktop apps, that're managed via Flatpak    #
# Apps are sorted by category, and arranged alphabetically     #
# Be sure to delete / comment out anything you do not need     #
# For more info, see: https://wiki.debian.org/Apt              #
################################################################
# MIT Licensed (C) Alicia Sykes 2023 <https://aliciasykes.com> #
################################################################

### TO ADD THROUGH APT :
# - signal
# - vscode
# - VLC         => MIGRATED TO SNAP NOW
# - uploadedlobster
# - fr.handbrake.ghb'          # Video transcoder
# - nl.hjdskes.gcolor3'        # Color picker
# - flameshot
# - cc.arduino.IDE2'           # IOT development
# - com.axosoft.GitKraken'     # GUI git client
# - io.podman_desktop.PodmanDesktop' # Docker / Podman UI
# - wireshark
# - podman
# - org.bleachbit.BleachBit'   # Disk cleaner and log remover
# - filezillaproject.Filezilla
# - obsidian.Obsidian'        # Markdown editor
# - belmoussaoui.Authenticator'  # OTP authenticator

# Apps to be installed via apt-get
debian_apps=(
  # Essentials
  'git'                       # Version controll
  'ranger'                    # Directory browser
  'tmux'                      # Term multiplexer
  'wget'                      # Download files
  'zsh'                       # Shell of choice
  'geany'                     # text editor
  'geany-plugin*'             # text editor
  'curl'                      # curl
  'zsh-syntax-highlighting'
  'terminator'
  'gpg'
  'ca-certificates'
  'jq'
  'menulibre'
  'xdotool'
  'libxcb-cursor0'
  'libxcb-xtest0'
  'libxcb-xinerama0'
  'net-tools'
  'traceroute'
  'gir1.2-gda-5.0'
  'gir1.2-gsound-1.0'
  'wl-clipboard'              # xclip replacement for wayland
  'floorp'                    # browser replacement for firefox
  'file-roller'               # for archive management

  # CLI Power Basics
  'aria2'         # Resuming download util (better wget)
  'bat'           # Output highlighting (better cat)
  'broot'         # Interactive directory navigation
  'ctags'         # Indexing of file info + headers
  'copyq'         # clipboard manager
  'diff-so-fancy' # Readable file compares (better diff)
  'duf'           # Get info on mounted disks (better df)
  'eza'           # Listing files with info (better ls)
  'flameshot'     # print screen
  'fzf'           # Fuzzy file finder and filtering
  'hyperfine'     # Benchmarking for arbitrary commands
  #'just'          # Powerful command runner (better make)
  'jq'            # JSON parser, output and query files
  'most'          # Multi-window scroll pager (better less)
  'mc'            # midnight commander
  #'procs'         # Advanced process viewer (better ps)
  'ripgrep'       # Searching within files (better grep)
  'scrot'         # Screenshots programmatically via CLI
  #'sd'            # RegEx find and replace (better sed)
#  'thefuck'       # Auto-correct miss-typed commands   # TODO : investigate why crashing
  #'tealdeer'      # Reader for command docs (better man)
  'tree'          # Directory listings as tree structure
  'ripgrep'
  'fd-find'
  'silversearcher-ag' # source code searching tool 
  'unzip'
  'bat'
  'plocate'
  'stow'
  #'tokei'         # Count lines of code (better cloc)
  'trash-cli'     # Record and restore removed files
  'xsel'          # Copy paste access to the X clipboard
  'zoxide'        # Auto-learning navigation (better cd)
  'gwakeonlan'    # wakes up your machines using Wake on LAN

  # Languages, compilers, runtimes, etc
  'golang'
  'nodejs'
  'npm'
  'python3-dev'
  'python3-pip' 
  'libsqlite3-dev'
  'libssl-dev' 
  'ninja-build' 
  'gettext' 
  'libtool'
  'libtool-bin' 
  'autoconf'
  'automake'
  'cmake'
  'g++'
  'pkg-config'
  'doxygen'
  'libicu-dev'
  'libboost-all-dev'
  'build-essential'
  'make'
  'zlib1g-dev'
  'libbz2-dev'
  'libreadline-dev'
  'llvm'
  'libncurses-dev'
  'xz-utils'
  'tk-dev'
  'libffi-dev'
  'liblzma-dev'
  'libevent-dev'
  'bison'
  'dupeguru'            # GUI tool to find duplicate files in a system
  'meld'                # graphical tool to diff and merge files
  'tcpdump'             # command-line network traffic analyzer
  'ssldump'             # ssldump

  # Security Utilities
  'clamav'            # Open source virus scanning suite
  'cryptsetup'        # Reading / writing encrypted volumes
  'gnupg'             # PGP encryption, signing and verifying
  'git-crypt'         # Transparent encryption for git repos
  'lynis'             # Scan system for common security issues
  'openssl'           # Cryptography and SSL/TLS Toolkit
  'rkhunter'          # Search / detect potential root kits
  'wireguard'         # wireguard VPN
  'backintime-common' # backup
  'gparted'           # disk management

  # Monitoring, management and stats
  'btop'          # Live system resource monitoring
  'bmon'          # Bandwidth utilization monitor
  'htop'          # better top
  'iftop'         # network top
  'docker-ctop'   # Container metrics and monitoring
  'gping'         # Interactive ping tool, with graph
  'glances'       # Resource monitor + web and API
  'goaccess'      # Web log analyzer and viewer
  'speedtest-cli' # Command line speed test utility

  # CLI Fun
  'cowsay'        # Outputs message with ASCII art cow
  'figlet'        # Outputs text as 3D ASCII word art
  'lolcat'        # Rainbow colored terminal output
  'neofetch'      # Show off distro and system info

  # misc lib
  'libgdk-pixbuf-xlib-2.0-0'
  'libgdk-pixbuf2.0-0'
)

ubuntu_repos=(
  'main'
  'universe'
  'restricted'
  'multiverse'
)

debian_repos=(
  'main'
  'contrib'
)

dashbar_apps=(
  'terminator.desktop'
  'geany.desktop'
  'floorp.desktop'
  'org.gnome.Settings.desktop'
  'menulibre.desktop'
)

# Following packages not found by apt, need to fix:
# aria2, bat, broot, diff-so-fancy, duf, hyperfine,
# just, procs, ripgrep, sd, tealdeer, tokei, trash-cli,
# zoxide, clamav, cryptsetup, gnupg, lynis, btop, gping.


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
echo -e "${PURPLE}Starting Debian/ Ubuntu package install & update script"
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

# Enable upstream package repositories
echo -e "${CYAN_B}Would you like to enable listed repos? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  if ! hash add-apt-repository 2> /dev/null; then
    sudo apt install --reinstall software-properties-common
  fi
  # If Ubuntu, add Ubuntu repos
  if lsb_release -a 2>/dev/null | grep -q 'Ubuntu'; then
    for repo in ${ubuntu_repos[@]}; do
      echo -e "${PURPLE}Enabling ${repo} repo...${RESET}"
      sudo add-apt-repository -y $repo
    done
  else
    # Otherwise, add Debian repos
    for repo in ${debian_repos[@]}; do
      echo -e "${PURPLE}Enabling ${repo} repo...${RESET}"
      sudo add-apt-repository $repo
    done
  fi
fi

# adding additional repository
echo -e "${CYAN_B}Would you like to add another repository? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${PURPLE}adding repository...${RESET}"
  echo "deb http://packages.azlux.fr/debian/ stable main" | sudo tee /etc/apt/sources.list.d/azlux.list
  #sudo wget -O /usr/share/keyrings/azlux-archive-keyring.gpg  https://azlux.fr/repo.gpgrepo
  wget -qO - https://azlux.fr/repo.gpg.key | sudo apt-key add -

  sudo add-apt-repository -y ppa:aos1/diff-so-fancy

  # for floorp 
  curl -fsSL https://ppa.ablaze.one/KEY.gpg | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/Floorp.gpg
  sudo curl -sS --compressed -o /etc/apt/sources.list.d/Floorp.list 'https://ppa.ablaze.one/Floorp.list'

  # for docker
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

fi

# Prompt user to update package database
echo -e "${CYAN_B}Would you like to update package database? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${PURPLE}Updating database...${RESET}"
  sudo apt update
fi

# Prompt user to upgrade currently installed packages
echo -e "${CYAN_B}Would you like to upgrade currently installed packages? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${PURPLE}Upgrading installed packages...${RESET}"
  sudo apt upgrade -y
fi

# Prompt user to clear old package caches
echo -e "${CYAN_B}Would you like to clear unused package caches? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${PURPLE}Freeing up disk space...${RESET}"
  sudo apt autoclean
fi

# removing uwanted shortcut in bar
# TODO: make a loop instead
echo -e "${CYAN_B}Would you like to remove uwanted apps to bar? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${PURPLE}Starting removing shortcut...${RESET}"
  APPPP=$(gsettings get org.gnome.shell favorite-apps | sed 's/, '\''libreoffice-writer.desktop'\''//ig' | sed 's/, '\''.desktop'\''//ig' |sed 's/, '\''yelp.desktop'\''//ig' |sed 's/, '\''snap-store_ubuntu-software.desktop'\''//ig')
  gsettings set org.gnome.shell favorite-apps "$APPPP"

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

# install additionnal fonts
echo -e "${CYAN_B}Would you like to install additionnal fonts? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  cd ~/.local/share && \
  mkdir -p fonts && \
  cd fonts && \
  wget -O Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip && \
  unzip -o Hack.zip && \
  rm -rf Hack.zip
fi

# install gitui
echo -e "${CYAN_B}Would you like to install GITUI? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  ARCHITECTURE=x86_64
  /bin/curl -iL -s https://api.github.com/repos/extrawurst/gitui/releases/latest | /bin/grep -wo "https.*gitui.*linux.*${ARCHITECTURE}.*tar.gz" | /bin/wget -O ~/Downloads/gitui.tar.gz -qi -
  /bin/tar xzvf ~/Downloads/gitui.tar.gz
  /bin/sudo /bin/chown root:root gitui
  /bin/sudo /bin/chmod u=rwx,g=rx,o=rx gitui
  /bin/sudo /bin/mv gitui /usr/local/bin/
  /bin/rm ~/Downloads/gitui.tar.gz
  /bin/rm gitui 2> /dev/null
fi

# install rust
echo -e "${CYAN_B}Would you like to install RUST? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# install balena etcher
echo -e "${CYAN_B}Would you like to install balena etcher? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  NAME=$(/bin/curl -s https://api.github.com/repos/balena-io/etcher/releases/latest  | \
  jq -r '.assets[] | select(.name | contains ("deb")) | .name') ; /bin/curl --location --silent  $(/bin/curl -s https://api.github.com/repos/balena-io/etcher/releases/latest  | \
  jq -r '.assets[] | select(.name | contains ("deb")) | .browser_download_url') --output ${NAME} && sudo apt install -y ./${NAME}
  rm ./${NAME}
fi

# install ente auth
echo -e "${CYAN_B}Would you like to install ente auth? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  NAME=$(/bin/curl -s https://api.github.com/repos/ente-io/photos-desktop/releases/latest  | \
  jq -r '.assets[] | select(.name | contains ("deb") and contains ("amd64")) | .name') ; /bin/curl --location --silent  $(/bin/curl -s https://api.github.com/repos/ente-io/photos-desktop/releases/latest  | \
  jq -r '.assets[] | select(.name | contains ("deb") and contains ("amd64")) | .browser_download_url') --output ${NAME} && sudo apt install -y ./${NAME}
  rm ./${NAME}
fi

# adding shortcut to bar
echo -e "${CYAN_B}Would you like to install shortcut to bar? (y/N)${RESET}\n"
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

# install thefuck with PIP as package is broken on ubuntu24.04
echo -e "${CYAN_B}Would you like to install some needed pip package? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${PURPLE}setup thefuck...${RESET}"
  sudo pip3 install git+https://github.com/nvbn/thefuck --break-system-packages

fi

# installing pyenv
echo -e "${CYAN_B}Would you like to pyenv? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${PURPLE}setup pyenv...${RESET}"
  curl https://pyenv.run | bash
  # # zsh
  # echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
  # echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
  # echo 'eval "$(pyenv init -)"' >> ~/.zshrc
  # # zsh non interactive
  # echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zprofile
  # echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zprofile
  # echo 'eval "$(pyenv init -)"' >> ~/.zprofile
  # # bash 
  # echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
  # echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
  # echo 'eval "$(pyenv init -)"' >> ~/.bashrc
fi

# using flameshot instead of default gnome screenshot tool
# to review
echo -e "${CYAN_B}Would you like to use flameshot for default screenshot? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${PURPLE}setup flameshot...${RESET}"
  # not working anymore in ubuntu > 19.10.
  # use ... instead
  # removing default screenshot shortcut to printScr key
  # gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot '[]'

  # adding screenshot script to printScr key.
  # Warning due to a bug in wayland need to use a wrapper as workaround
  sudo tee /usr/local/bin/flameshot-gui-workaround > /dev/null <<'EOF'
#!/bin/bash
# workaround thanks to https://github.com/flatpak/xdg-desktop-portal/issues/1070#issuecomment-1762884545
env QT_QPA_PLATFORM=wayland flameshot gui

EOF

  sudo chmod a+x /usr/local/bin/flameshot-gui-workaround

  gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'flameshot'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command '/usr/local/bin/flameshot-gui-workaround'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding 'Print'
fi


echo -e "${CYAN_B}Would you like to FIX floorp warning message and create a floorp profile? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${PURPLE}fix floorp error message...${RESET}"
  sudo tee /etc/apparmor.d/floorp-local > /dev/null <<'EOF'
abi <abi/4.0>,
include <tunables/global>
profile floorp-local
/usr/lib/floorp/{floorp,floorp-bin,updater}
flags=(unconfined) {

userns,
include if exists <local/floorp>
}

EOF
  sudo systemctl restart apparmor.service
/usr/bin/floorp -CreateProfile "MyProfile"
fi

echo -e "${PURPLE}Finished installing / updating Debian packages.${RESET}"

# gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed s/.$//), 'code.desktop']"
# gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed s/.$//), 'virt-manager.desktop']"

# EOF
