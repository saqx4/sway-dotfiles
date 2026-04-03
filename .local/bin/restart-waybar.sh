#!/bin/bash
# Restart waybar to apply changes
killall waybar 2>/dev/null
sleep 1
waybar &
echo "Waybar restarted"
