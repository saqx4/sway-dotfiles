#!/bin/bash
# WiFi network selector using rofi

# Get list of available WiFi networks
networks=$(nmcli -t -f SSID,SECURITY,SIGNAL dev wifi | grep -v "^$" | sort -t: -k3 -rn | head -20)

if [ -z "$networks" ]; then
    notify-send "WiFi" "No networks found"
    exit 1
fi

# Show networks in rofi
selected=$(echo "$networks" | rofi -dmenu -p "WiFi Networks" -l 10 -i)

if [ -z "$selected" ]; then
    exit 0
fi

# Extract SSID
ssid=$(echo "$selected" | cut -d: -f1)

# Check if already connected
current=$(nmcli -t -f ACTIVE,SSID dev wifi | grep "^yes" | cut -d: -f2)
if [ "$ssid" = "$current" ]; then
    notify-send "WiFi" "Already connected to $ssid"
    exit 0
fi

# If network is secured, ask for password
security=$(echo "$selected" | cut -d: -f2)
if [ "$security" != "" ]; then
    password=$(rofi -dmenu -p "Password for $ssid" -password)
    if [ -z "$password" ]; then
        exit 0
    fi
    nmcli dev wifi connect "$ssid" password "$password" 2>/dev/null
else
    nmcli dev wifi connect "$ssid" 2>/dev/null
fi

# Show result
if [ $? -eq 0 ]; then
    notify-send "WiFi" "Connected to $ssid"
else
    notify-send "WiFi" "Failed to connect to $ssid"
fi
