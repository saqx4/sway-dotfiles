#!/bin/bash
chosen=$(printf "Lock\nLogout\nReboot\nShutdown\nSuspend" | rofi -dmenu -p "Power" -l 5)

case "$chosen" in
    Lock) swaylock -f -c 000000 ;;
    Logout) swaymsg exit ;;
    Reboot) systemctl reboot ;;
    Shutdown) systemctl poweroff ;;
    Suspend) systemctl suspend ;;
esac
