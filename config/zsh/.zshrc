######################################################################
# ~/.config/zsh/.zshrc                                               #
######################################################################
# Instructions to be executed when a new ZSH session is launched     #
# Imports all plugins, aliases, helper functions, and configurations #
#                                                                    #
# After editing, re-source .zshrc for new changes to take effect     #
# For docs and more info, see: https://github.com/emmanuelvargas/dotfiles   #
######################################################################
# Licensed under MIT (C) Alicia Sykes 2022 <https://aliciasykes.com> #
######################################################################

# Directory for all-things ZSH config
zsh_dir=${${ZDOTDIR}:-$HOME/.config/zsh}
utils_dir="${XDG_CONFIG_HOME}/utils"

# Import private ENV
[[ ! -f ${zsh_dir}/.zshenv_private ]] || source ${zsh_dir}/.zshenv_private

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Import utility functions (if present)
if [[ -d $utils_dir ]]; then
  source ${utils_dir}/transfer.sh
  source ${utils_dir}/matrix.sh
  source ${utils_dir}/hr.sh
  source ${utils_dir}/web-search.sh
  source ${utils_dir}/am-i-online.sh
  source ${utils_dir}/welcome-banner.sh
  source ${utils_dir}/color-map.sh
  source ${utils_dir}/unused-vid-helper.sh
fi

# Import P10k config for command prompt
[[ ! -f ${zsh_dir}/.p10k.zsh ]] || source ${zsh_dir}/.p10k.zsh

# Source all ZSH config files (if present)
if [[ -d $zsh_dir ]]; then
  # Import alias files
  source ${zsh_dir}/aliases/general.zsh
  source ${zsh_dir}/aliases/git.zsh
  source ${zsh_dir}/aliases/node-js.zsh
  source ${zsh_dir}/aliases/rust.zsh
  source ${zsh_dir}/aliases/flutter.zsh
  source ${zsh_dir}/aliases/tmux.zsh
  source ${zsh_dir}/aliases/alias-tips.zsh
  source ${zsh_dir}/aliases/private-alias.zsh
  source ${zsh_dir}/aliases/pro-alias.zsh

  # Setup Antigen, and import plugins
  source ${zsh_dir}/helpers/setup-antigen.zsh
  source ${zsh_dir}/helpers/import-plugins.zsh
  source ${zsh_dir}/helpers/misc-stuff.zsh

  # Configure ZSH stuff
  source ${zsh_dir}/lib/colors.zsh
  source ${zsh_dir}/lib/cursor.zsh
  source ${zsh_dir}/lib/history.zsh
  source ${zsh_dir}/lib/surround.zsh
  source ${zsh_dir}/lib/completion.zsh
  source ${zsh_dir}/lib/term-title.zsh
  source ${zsh_dir}/lib/navigation.zsh
  source ${zsh_dir}/lib/expansions.zsh
  source ${zsh_dir}/lib/key-bindings.zsh
fi

# If using Pyenv, import the shell integration if availible
if [[ -d "$PYENV_ROOT" ]] && \
  command -v pyenv >/dev/null 2>&1 && \
  command -v pyenv-virtualenv-init >/dev/null; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# If using Tilix, import the shell integration if availible
if [ $TILIX_ID ] || [ $VTE_VERSION ] && [[ -f "/etc/profile.d/vte.sh" ]]; then
  source /etc/profile.d/vte.sh
fi

# Append Cargo to path, if it's installed
if [[ -d "$HOME/.cargo/bin" ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# Append Deno to path, if it's installed
if [[ -d "$HOME/.deno" ]]; then
  export DENO_INSTALL="$HOME/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"
fi

# Append flatpak to path
export PATH="/var/lib/flatpak/exports/bin:$PATH"

# Add Zoxide (for cd, quick jump) to shell
if hash zoxide 2> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# If not running in nested shell, then show welcome message :)
if [[ "${SHLVL}" -lt 2 ]] && \
  { [[ -z "$SKIP_WELCOME" ]] || [[ "$SKIP_WELCOME" == "false" ]]; }; then
  welcome
fi

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
