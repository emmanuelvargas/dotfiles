#!/usr/bin/env bash

######################################################################
# Linux Desktop copy some secrects from bitwarden private server     #
######################################################################
# This script will:                                                  #
######################################################################
# Licensed under MIT (C) Emmanuel Vargas 2024 #
######################################################################

# TO ADAPT FOLLOWING YOUR BITWARDEN SETUP
BW_FOLDER_CONFIG_ENV="CONFIG_ENV"
BW_ALIAS_PERSO="ALIAS_PRIVATE"
BW_ALIAS_WORK="ALIAS_PRO"
BW_SSHCONFIG="CONFIG_SSHCONFIG"
BW_FOLDER_SSHKEY="CONFIG_SSHKEY"

# TODO: 
# ALIASES
# ENV
# SSH KEY
# ssh config
# CLOGINRC ?
# GITHUB / GITLAB config

# TODO: add variable to doc
# TODO: add parameter to bypass this step

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


function print_usage () {
  echo -e "${CYAN_B}Linux Desktop copy some secrects from bitwarden private server${RESET}"
  echo -e "${PURPLE}The following tasks will be completed:\n"\
  "- Check bw is installed correctly / prompt to install if not\n"\
  "- Check needed variables are presents and request them if not of finish\n"\
	"- Connect and auth to bitwarden self hosted sever or bitwarden.com\n"\
	"- Add pro and perso aliases\n"\
	"- Add pro and perso env variables like login/password/api key\n"\
	"- Add pro and perso ssh private and pub keys\n"\
	"- Add ssh client config\n"\
	"- Add cloginrc\n"\
	"- Add github / gitlab config\n"\
  "${RESET}"
}

# Show help menu
print_usage
if [[ $PARAMS == *"--help"* ]]; then exit; fi

# Ask user if they'd like to proceed, and exit if not
echo -e "${CYAN_B}Would you like to install secrets from bitwarden server? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]] && [[ $AUTO_YES != true ]] ; then
  echo -e "${YELLOW}Skipping Secrets installations..."
  exit 0
fi

echo -e "${CYAN_B}Starting secrets installation Script${RESET}"

# Check that Flatpak is present, prompt to install or exit if not
if ! hash bw 2> /dev/null; then
  echo -e "${PURPLE}bitwarden cli (bw) isn't yet installed on your system${RESET}"
  echo -e "${CYAN_B}Would you like to install bw from Flatpak now?${RESET}\n"
  read -t $PROMPT_TIMEOUT -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]] || [[ $AUTO_YES = true ]] ; then
    sudo flatpak install -y --noninteractive flathub com.bitwarden.desktop
  else
    echo -e "${YELLOW}Skipping secrets installations, as bitwarden cli (bw) not installed"
    exit 0
  fi
fi

function select_bw_server () {
	if [[ $BW_SERVER ]]; then
		bw config server $BW_SERVER --quiet
	fi
}

function auth_bw_server () {
	bw login --apikey --quiet
	BW_SESSION=$(bw unlock --passwordenv BW_PASSWORD | grep export | cut -d '"' -f 2 | tr -d '"')

}

function logout_bw_server () {
	bw logout --quiet
}

function get_aliases () {
  ZSHENVPRIV="${HOME}/.config/zsh/.zshenv_private"
  cat >$ZSHENVPRIV <<EOL
######################################################################
# Private ZSH ENV                                                    #
# All theses are privates ENV   are stored in bitwarden              #
# and append to file later in script                                 #
#                                                                    #
######################################################################
 
EOL

	FOLDERID=$(bw list folders --search $BW_FOLDER_CONFIG_ENV --session=$BW_SESSION |jq '.[].id' | tr -d '"')
	bw list items --folderid $FOLDERID --session=$BW_SESSION | jq -r '
    .[] | "export \(.name | gsub("[^A-Za-z_]"; ""))=\(.notes | @sh)"' >> "$ZSHENVPRIV"
}

function get_env_pro_perso () {
  # private alias
  ZSHALIASPRIV="${HOME}/.config/zsh/aliases/private-alias.zsh"
  cat >$ZSHALIASPRIV <<EOL
######################################################################
# Private ZSH ALIAS                                                  #
# All theses are privates alias are stored in bitwarden              #
# and append to file later in script                                 #
#                                                                    #
######################################################################
 
EOL

	bw get notes $BW_ALIAS_PERSO --session "${BW_SESSION}" >> "$ZSHALIASPRIV"

  # private work alias
  ZSHALIASWORK="${HOME}/.config/zsh/aliases/pro-alias.zsh"
  cat >$ZSHALIASWORK <<EOL
######################################################################
# Private ZSH ALIAS                                                  #
# All theses are privates alias are stored in bitwarden              #
# and append to file later in script                                 #
#                                                                    #
######################################################################
 
EOL

	bw get notes $BW_ALIAS_WORK --session "${BW_SESSION}" >> "$ZSHALIASWORK"

}

function get_sshkeys () {
  FOLDERID=$(bw list folders --search $BW_FOLDER_SSHKEY --session=$BW_SESSION |jq '.[].id' | tr -d '"')
	bw list items --folderid $FOLDERID --session=$BW_SESSION | jq -c '.[] | "\(.name) \(.notes)"' | tr -d '"' | while read -r NAME NOTE; do echo -e "$NOTE" > ~/.ssh/$NAME && chmod 600 ~/.ssh/$NAME ; done
}

function get_ssh_config () {
  # make a copy first
  sshconfig_file="~/.ssh/config"

  if [ -e $sshconfig_file ]; then
      cp $sshconfig_file $sshconfig_file.$(date +'%Y%d%m')
  fi
  # private ssh config
  SSHCONFIGFILE="${HOME}/.config/ssh/config"
  if [ -e $SSHCONFIGFILE ]; then
      chmod 600 $SSHCONFIGFILE
      cp $SSHCONFIGFILE $SSHCONFIGFILE.$(date +'%Y%d%m')
  fi
  cat >$SSHCONFIGFILE <<EOL
######################################################################
# This file is managed by script                                     #
#   DO NOT EDIT OR THE CHANGES WILL BE LOST                          #
#  Edit the conf in bitwarden                                        #
######################################################################

 
EOL

	bw get notes $BW_SSHCONFIG --session "${BW_SESSION}" >> "$SSHCONFIGFILE"

}

function get_cloginrc () {
	return 0
}

function get_github_gitlab () {
	return 0
}


select_bw_server

auth_bw_server

get_aliases

get_env_pro_perso

get_sshkeys

get_ssh_config

get_cloginrc

get_github_gitlab

logout_bw_server

echo -e "${PURPLE}Finished processing Secrets${RESET}"
