#
# ~/.bash_profile
#

# Environment variables for Wayland/Sway
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=sway
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export GDK_BACKEND=wayland,x11
export SDL_VIDEODRIVER=wayland
export CLUTTER_BACKEND=wayland
export GTK_ICON_THEME=Papirus

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Auto-start sway from tty1
if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]]; then
    exec sway
fi
