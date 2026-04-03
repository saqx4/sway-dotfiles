# Sway Window Manager - Quick Reference Guide

## 🚀 Starting Sway

From TTY, run: `sway`

Or add to `~/.bash_profile` to auto-start:
```bash
if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]]; then
    exec sway
fi
```

## ⌨️ Keybindings

### Essential
| Keybinding | Action |
|------------|--------|
| `Super + Enter` | Open Terminal (kitty) |
| `Super + D` | Open App Launcher (wofi) |
| `Super + Shift + D` | Open Window Switcher |
| `Super + B` | Open Browser (Firefox) |
| `Super + E` | Open File Manager (Thunar) |
| `Super + Shift + E` | Power Menu |
| `Super + Escape` | Lock Screen |
| `Super + Shift + C` | Reload Config |
| `Super + Shift + R` | Restart Sway |
| `Super + Shift + Q` | Kill Focused Window |

### Navigation
| Keybinding | Action |
|------------|--------|
| `Super + H/J/K/L` | Focus Left/Down/Up/Right |
| `Super + 1-0` | Switch to Workspace 1-10 |
| `Super + Tab` | Switch to Previous Workspace |

### Moving Windows
| Keybinding | Action |
|------------|--------|
| `Super + Shift + H/J/K/L` | Move Window Left/Down/Up/Right |
| `Super + Shift + 1-0` | Move to Workspace 1-10 |

### Layout & Display
| Keybinding | Action |
|------------|--------|
| `Super + F` | Toggle Fullscreen |
| `Super + Shift + F` | Toggle Floating |
| `Super + V` | Toggle Split Layout |
| `Super + S` | Stacking Layout |
| `Super + T` | Tabbed Layout |
| `Super + R` | Enter Resize Mode (press R/Esc to exit) |

### Screenshots 📸
| Keybinding | Action |
|------------|--------|
| `Print` | Full Screenshot |
| `Ctrl + Print` | Select Area Screenshot |
| `Shift + Print` | Copy Area to Clipboard |

Manual: `~/Scripts/screenshot.sh [full|select|window|clipboard]`

### Media Keys
| Key | Action |
|-----|--------|
| `Volume Up/Down/Mute` | Control Audio |
| `Mic Mute` | Toggle Microphone |
| `Play/Pause/Next/Prev` | Media Control |
| `Brightness Up/Down` | Screen Brightness |

### Scratchpad
| Keybinding | Action |
|------------|--------|
| `Super + Shift + Minus` | Send to Scratchpad |
| `Super + Minus` | Show Scratchpad |

## 📁 Configuration Files

| File | Purpose |
|------|---------|
| `~/.config/sway/config` | Main Sway config |
| `~/.config/waybar/config.json` | Waybar modules |
| `~/.config/waybar/style.css` | Waybar appearance |
| `~/.config/mako/config` | Notification daemon |
| `~/.config/wofi/config` | App launcher config |
| `~/.config/wofi/style.css` | App launcher appearance |

## 🛠️ Installed Tools

- **kitty** - Terminal emulator
- **wofi** - Application launcher
- **waybar** - Status bar
- **mako** - Notification daemon
- **swaybg** - Wallpaper setter
- **swaylock** - Screen locker
- **swayidle** - Idle management
- **grim** - Screenshot tool
- **slurp** - Region selector
- **wl-clipboard** - Clipboard management
- **cliphist** - Clipboard history
- **playerctl** - Media player control
- **brightnessctl** - Brightness control
- **thunar** - File manager
- **wf-recorder** - Screen recording

## 💡 Useful Commands

```bash
# Reload sway config
swaymsg reload

# View all connected inputs
swaymsg -t get_inputs

# View all outputs (displays)
swaymsg -t get_outputs

# List all workspaces
swaymsg -t get_workspaces

# Check sway version
swaymsg -t get_version

# Manually lock screen
swaylock -f -c 000000

# Set wallpaper
swaybg -i /path/to/image.png -m fill

# Clipboard history
cliphist list | wofi --dmenu | cliphist decode | wl-copy
```

## 🔧 Troubleshooting

### Apps not starting on Wayland
Most apps should auto-detect Wayland. Force with:
- Firefox: `MOZ_ENABLE_WAYLAND=1 firefox`
- Chrome: `google-chrome --ozone-platform=wayland`

### Screen won't lock
Make sure swaylock is properly configured:
```bash
swaylock -f -c 000000
```

### No notifications
Check if mako is running:
```bash
systemctl --user status mako
```

### Waybar not showing
Restart waybar:
```bash
killall waybar && waybar &
```

## 📝 Tips

1. **Clipboard**: Use `wl-copy` and `wl-paste` for clipboard operations
2. **Screen recording**: Use `wf-recorder -g "$(slurp)" -o output.mp4`
3. **Color picking**: Use `~/Scripts/colorpicker.sh`
4. **Power menu**: Use `~/Scripts/powermenu.sh`
5. **Screenshots**: All saved to `~/Pictures/`

## 🎨 Theme

This config uses **Catppuccin Mocha** color scheme:
- Background: `#1e1e2e`
- Text: `#cdd6f4`
- Blue: `#89b4fa`
- Green: `#a6e3a1`
- Red: `#f38ba8`
- Yellow: `#f9e2af`
