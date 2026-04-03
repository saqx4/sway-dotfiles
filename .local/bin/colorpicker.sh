#!/bin/bash
# Color picker script for Sway
# Requires: hyprpicker or slurp+grim

if command -v hyprpicker &>/dev/null; then
    hyprpicker -a
else
    # Fallback: pick color from screen area
    COLOR=$(grim -g "$(slurp -p)" -t ppm - | convert - -format '%[pixel:p{0,0}]' txt:- 2>/dev/null | tail -n 1 | awk '{print $3}')
    if [ -n "$COLOR" ]; then
        echo "$COLOR" | wl-copy
        notify-send "Color Picker" "Color $COLOR copied to clipboard"
    fi
fi
