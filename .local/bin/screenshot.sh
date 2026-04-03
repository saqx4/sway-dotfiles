#!/bin/bash
# Screenshot script for Sway
# Usage: screenshot.sh [full|select|window]

SCREENSHOTS_DIR="$HOME/Pictures"
mkdir -p "$SCREENSHOTS_DIR"

TIMESTAMP=$(date +'%Y%m%d_%H%M%S')
FILEPATH="$SCREENSHOTS_DIR/Screenshot_${TIMESTAMP}.png"

case "$1" in
    full)
        # Screenshot entire screen
        grim "$FILEPATH"
        notify-send "Screenshot" "Full screenshot saved" -i "image"
        ;;
    select|area)
        # Screenshot selected area
        grim -g "$(slurp)" "$FILEPATH"
        notify-send "Screenshot" "Area screenshot saved" -i "image"
        ;;
    window)
        # Screenshot focused window
        grim -g "$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | head -n 1)" "$FILEPATH"
        notify-send "Screenshot" "Window screenshot saved" -i "image"
        ;;
    clipboard)
        # Screenshot area to clipboard
        grim -g "$(slurp)" - | wl-copy
        notify-send "Screenshot" "Screenshot copied to clipboard" -i "image"
        ;;
    *)
        echo "Usage: $0 {full|select|window|clipboard}"
        exit 1
        ;;
esac

# Copy to clipboard as well
wl-copy < "$FILEPATH"
