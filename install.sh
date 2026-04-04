#!/usr/bin/env bash
#
# Sway Dotfiles Installer
# Installs dependencies and applies dotfiles to your system
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ============================================================
# Helper Functions
# ============================================================

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_command() {
    command -v "$1" &>/dev/null
}

# ============================================================
# Detect Package Manager
# ============================================================

detect_package_manager() {
    if check_command pacman; then
        PKG_MANAGER="pacman"
        PKG_INSTALL="sudo pacman -S --needed --noconfirm"
        PKG_AUR="yay -S --needed --noconfirm"
        info "Detected Arch Linux (pacman)"
    elif check_command dnf; then
        PKG_MANAGER="dnf"
        PKG_INSTALL="sudo dnf install -y"
        info "Detected Fedora/RHEL (dnf)"
    elif check_command apt; then
        PKG_MANAGER="apt"
        PKG_INSTALL="sudo apt install -y"
        info "Detected Debian/Ubuntu (apt)"
    elif check_command zypper; then
        PKG_MANAGER="zypper"
        PKG_INSTALL="sudo zypper install -y"
        info "Detected openSUSE (zypper)"
    elif check_command nix; then
        PKG_MANAGER="nix"
        PKG_INSTALL="nix profile install"
        info "Detected Nix"
    else
        error "Unsupported package manager. Please install dependencies manually."
        exit 1
    fi
}

# ============================================================
# Install Dependencies
# ============================================================

install_dependencies() {
    info "Installing dependencies..."

    case "$PKG_MANAGER" in
        pacman)
            sudo pacman -Syyu --needed --noconfirm \
                sway \
                swaybg \
                swayidle \
                swaylock \
                waybar \
                mako \
                rofi-wayland \
                kitty \
                grim \
                slurp \
                wl-clipboard \
                cliphist \
                jq \
                pavucontrol \
                playerctl \
                brightnessctl \
                networkmanager \
                papm \
                fastfetch \
                ttf-font-awesome \
                otf-font-awesome \
                noto-fonts \
                noto-fonts-emoji \
                papirus-icon-theme \
                thunar \
                firefox \
                python-pip \
                || warn "Some packages may have failed to install"
            ;;
        apt)
            sudo apt update
            sudo apt install -y \
                sway \
                swaybg \
                swayidle \
                swaylock-effects \
                waybar \
                mako-notifier \
                rofi-wayland \
                kitty \
                grim \
                slurp \
                wl-clipboard \
                cliphist \
                jq \
                pavucontrol \
                playerctl \
                brightnessctl \
                network-manager \
                fastfetch \
                fonts-font-awesome \
                fonts-noto-color-emoji \
                papirus-icon-theme \
                thunar \
                firefox \
                python3-pip \
                || warn "Some packages may have failed to install"
            ;;
        dnf)
            sudo dnf install -y \
                sway \
                swaybg \
                swayidle \
                swaylock \
                waybar \
                mako \
                rofi-wayland \
                kitty \
                grim \
                slurp \
                wl-clipboard \
                cliphist \
                jq \
                pavucontrol \
                playerctl \
                brightnessctl \
                NetworkManager \
                fastfetch \
                fontawesome-fonts \
                google-noto-sans-fonts \
                papirus-icon-theme \
                thunar \
                firefox \
                python3-pip \
                || warn "Some packages may have failed to install"
            ;;
        zypper)
            sudo zypper install -y \
                sway \
                swaybg \
                swayidle \
                swaylock \
                waybar \
                mako \
                rofi-wayland \
                kitty \
                grim \
                slurp \
                wl-clipboard \
                cliphist \
                jq \
                pavucontrol \
                playerctl \
                brightnessctl \
                NetworkManager \
                fastfetch \
                fontawesome-fonts \
                noto-sans-fonts \
                papirus-icon-theme \
                thunar \
                firefox \
                python3-pip \
                || warn "Some packages may have failed to install"
            ;;
        nix)
            nix profile install nixpkgs#sway \
                nixpkgs#swaybg \
                nixpkgs#swayidle \
                nixpkgs#swaylock \
                nixpkgs#waybar \
                nixpkgs#mako \
                nixpkgs#rofi-wayland \
                nixpkgs#kitty \
                nixpkgs#grim \
                nixpkgs#slurp \
                nixpkgs#wl-clipboard \
                nixpkgs#cliphist \
                nixpkgs#jq \
                nixpkgs#pavucontrol \
                nixpkgs#playerctl \
                nixpkgs#brightnessctl \
                nixpkgs#networkmanager \
                nixpkgs#fastfetch \
                nixpkgs#font-awesome \
                nixpkgs#noto-fonts \
                nixpkgs#papirus-icon-theme \
                nixpkgs#thunar \
                nixpkgs#firefox \
                || warn "Some packages may have failed to install"
            ;;
    esac

    success "Dependencies installed"
}

# ============================================================
# Install Fonts
# ============================================================

install_fonts() {
    info "Checking fonts..."

    # Check if JetBrains Mono Nerd Font is available
    if ! fc-list | grep -qi "jetbrains mono"; then
        warn "JetBrains Mono Nerd Font not found. Installing..."

        FONT_DIR="$HOME/.local/share/fonts"
        mkdir -p "$FONT_DIR"

        # Download JetBrains Mono Nerd Font
        FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
        FONT_ARCHIVE="/tmp/jetbrains-mono-nerd.tar.xz"

        if check_command curl; then
            curl -L "$FONT_URL" -o "$FONT_ARCHIVE"
        elif check_command wget; then
            wget "$FONT_URL" -O "$FONT_ARCHIVE"
        else
            error "curl or wget required to download fonts"
            return
        fi

        tar -xf "$FONT_ARCHIVE" -C "$FONT_DIR"
        rm -f "$FONT_ARCHIVE"
        fc-cache -fv
        success "JetBrains Mono Nerd Font installed"
    else
        success "JetBrains Mono Nerd Font already installed"
    fi
}

# ============================================================
# Apply Dotfiles (Symlink)
# ============================================================

apply_dotfiles() {
    info "Applying dotfiles..."

    # Create config directories
    mkdir -p "$HOME/.config/sway"
    mkdir -p "$HOME/.config/waybar"
    mkdir -p "$HOME/.config/mako"
    mkdir -p "$HOME/.config/rofi"
    mkdir -p "$HOME/.config/kitty"
    mkdir -p "$HOME/.config/fastfetch"
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/Pictures/Wallpapers"
    mkdir -p "$HOME/Pictures"

    # Symlink config files
    local configs=(
        ".config/sway/config"
        ".config/sway/env"
        ".config/waybar/config.json"
        ".config/waybar/style.css"
        ".config/mako/config"
        ".config/rofi/config.rasi"
        ".config/kitty/kitty.conf"
        ".config/fastfetch/config.jsonc"
        ".bashrc"
        ".bash_profile"
    )

    for config in "${configs[@]}"; do
        local src="$DOTFILES_DIR/$config"
        local dst="$HOME/$config"

        if [ -f "$src" ]; then
            # Backup existing file if it's not a symlink to our dotfiles
            if [ -e "$dst" ] && [ ! -L "$dst" ]; then
                local backup="${dst}.bak.$(date +%Y%m%d%H%M%S)"
                warn "Backing up $config to $backup"
                mv "$dst" "$backup"
            fi

            # Create symlink
            ln -sf "$src" "$dst"
            success "Linked $config"
        else
            warn "Source file not found: $src"
        fi
    done

    # Symlink local bin scripts
    if [ -d "$DOTFILES_DIR/.local/bin" ]; then
        for script in "$DOTFILES_DIR/.local/bin/"*; do
            if [ -f "$script" ]; then
                local script_name="$(basename "$script")"
                local dst="$HOME/.local/bin/$script_name"

                if [ -e "$dst" ] && [ ! -L "$dst" ]; then
                    local backup="${dst}.bak.$(date +%Y%m%d%H%M%S)"
                    warn "Backing up $script_name to $backup"
                    mv "$dst" "$backup"
                fi

                ln -sf "$script" "$dst"
                success "Linked .local/bin/$script_name"
            fi
        done
    fi

    # Make scripts executable
    chmod +x "$HOME/.local/bin/"*.sh 2>/dev/null || true
    success "Made scripts executable"
}

# ============================================================
# Setup Pywal (Optional)
# ============================================================

setup_pywal() {
    info "Setting up pywal for dynamic theming..."

    if check_command pip3 || check_command pip; then
        if ! check_command wal; then
            pip3 install pywalfox 2>/dev/null || pip install pywalfox 2>/dev/null || warn "Failed to install pywal"
        fi

        # Set a default wallpaper if none exists
        local default_wallpaper="$HOME/Pictures/Wallpapers/default.jpg"
        if [ ! -f "$default_wallpaper" ]; then
            warn "No default wallpaper found. Please set one using wal -i <path>"
            warn "Then run: wal -i <path> to generate colors"
        fi

        success "Pywal setup complete"
    else
        warn "pip not found. Install pywal manually: pip install pywal"
    fi
}

# ============================================================
# Enable Services
# ============================================================

enable_services() {
    info "Enabling system services..."

    # Enable NetworkManager if not already enabled
    if systemctl is-enabled NetworkManager &>/dev/null; then
        if ! systemctl is-active NetworkManager &>/dev/null; then
            sudo systemctl enable NetworkManager
            sudo systemctl start NetworkManager
            success "NetworkManager enabled"
        fi
    fi

    # Enable cliphist service for clipboard history
    info "Clipboard history will start on next Sway session"
}

# ============================================================
# Fix Paths in Configs
# ============================================================

fix_user_paths() {
    info "Updating user-specific paths in configs..."

    # Update waybar power menu path
    local waybar_config="$DOTFILES_DIR/.config/waybar/config.json"
    if [ -f "$waybar_config" ]; then
        sed -i "s|/home/sasa/Scripts/powermenu.sh|$HOME/.local/bin/powermenu.sh|g" "$waybar_config"
    fi

    # Update sway wallpaper path if needed
    local sway_config="$DOTFILES_DIR/.config/sway/config"
    if [ -f "$sway_config" ]; then
        sed -i "s|/home/sasa/Pictures/Wallpapers/general-1749388154.webp|$HOME/Pictures/Wallpapers/default.jpg|g" "$sway_config" 2>/dev/null || true
    fi

    success "User paths updated"
}

# ============================================================
# Print Usage Instructions
# ============================================================

print_instructions() {
    echo ""
    echo -e "${GREEN}============================================${NC}"
    echo -e "${GREEN}  Sway Dotfiles Installation Complete!     ${NC}"
    echo -e "${GREEN}============================================${NC}"
    echo ""
    echo "Next steps:"
    echo ""
    echo "1. ${YELLOW}Set a wallpaper${NC} (for pywal colors):"
    echo "   wal -i /path/to/wallpaper.jpg"
    echo ""
    echo "2. ${YELLOW}Start Sway${NC} (if not already running):"
    echo "   sway"
    echo ""
    echo "3. ${YELLOW}Reload Sway config${NC} (if already running):"
    echo "   Mod+Shift+c"
    echo ""
    echo "4. ${YELLOW}Set a default wallpaper${NC}:"
    echo "   Place a wallpaper in ~/Pictures/Wallpapers/"
    echo "   Then update ~/.config/sway/config with the path"
    echo ""
    echo -e "${BLUE}Key bindings:${NC}"
    echo "  Mod+Return  - Open terminal (kitty)"
    echo "  Mod+d       - Open app launcher (rofi)"
    echo "  Mod+b       - Open browser"
    echo "  Mod+e       - Open file manager"
    echo "  Mod+q       - Close window"
    echo "  Mod+f       - Toggle fullscreen"
    echo "  Mod+w       - Change wallpaper (pywal)"
    echo "  Print       - Screenshot (full)"
    echo "  Mod+Shift+e - Power menu"
    echo ""
}

# ============================================================
# Main
# ============================================================

main() {
    echo ""
    echo -e "${BLUE}============================================${NC}"
    echo -e "${BLUE}  Sway Dotfiles Installer                  ${NC}"
    echo -e "${BLUE}============================================${NC}"
    echo ""

    # Check if running as root
    if [ "$EUID" -eq 0 ]; then
        error "Please do not run this script as root"
        exit 1
    fi

    # Ask for confirmation
    read -rp "This will install Sway dotfiles and dependencies. Continue? [y/N] " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        info "Installation cancelled"
        exit 0
    fi

    # Step 1: Detect package manager
    detect_package_manager

    # Step 2: Install dependencies
    echo ""
    read -rp "Install dependencies? (may take a while) [y/N] " install_deps
    if [[ "$install_deps" =~ ^[Yy]$ ]]; then
        install_dependencies
    fi

    # Step 3: Install fonts
    echo ""
    install_fonts

    # Step 4: Apply dotfiles
    echo ""
    apply_dotfiles

    # Step 5: Fix user paths
    echo ""
    fix_user_paths

    # Step 6: Setup pywal
    echo ""
    read -rp "Setup pywal for dynamic theming? [y/N] " setup_pywal_choice
    if [[ "$setup_pywal_choice" =~ ^[Yy]$ ]]; then
        setup_pywal
    fi

    # Step 7: Enable services
    echo ""
    enable_services

    # Print instructions
    print_instructions
}

# Run main function
main "$@"
