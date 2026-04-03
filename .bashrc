#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Sway helpers
alias screenshot='~/.local/bin/screenshot.sh'
alias powermenu='~/.local/bin/powermenu.sh'
alias colorpicker='~/.local/bin/colorpicker.sh'
alias lockscreen='swaylock -f -c 000000'
alias reloadsway='swaymsg reload'
alias cliphist-view='cliphist list | rofi -dmenu | cliphist decode | wl-copy'
alias swayedit='kitty -e nano ~/.config/sway/config'
alias waybar-restart='killall waybar; waybar &'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Dotfiles alias
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
