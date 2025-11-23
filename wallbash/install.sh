#!/usr/bin/env bash
#|---/ /+----------------------------------+---/ /|#
#|--/ /-| Wallbash Standalone Installer    |--/ /-|#
#|-/ /--| Independent theming system       |-/ /--|#
#|/ /---+----------------------------------+/ /---|#

cat <<"EOF"

 _   _ _ _____ _   _               _
| | | |_|  _  | |_| |_ ___ ___ ___| |_
| | | | |     | | | | . | .'|_ -|   |
|_____|_|__|__|_|___|___|__,|___|_|_|

Standalone Wallpaper-based Theming System
-------------------------------------------

EOF

set -e

# Detect installation directory
INSTALL_DIR="$(dirname "$(realpath "$0")")"
BIN_DIR="$HOME/.local/bin"
SHARE_DIR="$HOME/.local/share/wallbash"
CONFIG_DIR="$HOME/.config/wallbash"
CACHE_DIR="$HOME/.cache/wallbash"

# Color output functions
print_msg() {
    case "$1" in
        info) echo -e "\e[34m[INFO]\e[0m $2" ;;
        success) echo -e "\e[32m[SUCCESS]\e[0m $2" ;;
        warn) echo -e "\e[33m[WARN]\e[0m $2" ;;
        error) echo -e "\e[31m[ERROR]\e[0m $2" ;;
        *) echo "$2" ;;
    esac
}

# Check dependencies
check_dependencies() {
    print_msg info "Checking dependencies..."
    
    local missing=()
    
    if ! command -v magick &>/dev/null && ! command -v convert &>/dev/null; then
        missing+=("imagemagick")
    fi
    
    if ! command -v parallel &>/dev/null; then
        print_msg warn "parallel not found - installation will be slower"
    fi
    
    if ! command -v jq &>/dev/null; then
        missing+=("jq")
    fi
    
    if [ ${#missing[@]} -gt 0 ]; then
        print_msg error "Missing required dependencies: ${missing[*]}"
        print_msg info "Install with: sudo pacman -S ${missing[*]}"
        exit 1
    fi
    
    print_msg success "All required dependencies found"
}

# Create directory structure
create_directories() {
    print_msg info "Creating directory structure..."
    
    mkdir -p "$BIN_DIR"
    mkdir -p "$SHARE_DIR"/{scripts,theme/{gtk,kvantum},always}
    mkdir -p "$CONFIG_DIR"
    mkdir -p "$CACHE_DIR"
    
    print_msg success "Directories created"
}

# Copy wallbash scripts
install_scripts() {
    print_msg info "Installing wallbash scripts..."
    
    # Copy main wallbash script
    if [ -f "${INSTALL_DIR}/bin/wallbash" ]; then
        cp "${INSTALL_DIR}/bin/wallbash" "$BIN_DIR/wallbash"
        chmod +x "$BIN_DIR/wallbash"
    fi
    
    # Copy color generation engine
    if [ -f "${INSTALL_DIR}/bin/color-set.sh" ]; then
        cp "${INSTALL_DIR}/bin/color-set.sh" "$BIN_DIR/wallbash-color-set"
        chmod +x "$BIN_DIR/wallbash-color-set"
    fi
    
    # Copy helper scripts
    for script in wallbash-toggle wallbash-print-colors wallbash-qt; do
        if [ -f "${INSTALL_DIR}/bin/${script}.sh" ]; then
            cp "${INSTALL_DIR}/bin/${script}.sh" "$BIN_DIR/${script}"
            chmod +x "$BIN_DIR/${script}"
        fi
    done
    
    print_msg success "Scripts installed to $BIN_DIR"
}

# Copy theme templates and resources
install_resources() {
    print_msg info "Installing theme templates and resources..."
    
    # Copy share files if they exist
    if [ -d "${INSTALL_DIR}/share/wallbash" ]; then
        cp -r "${INSTALL_DIR}/share/wallbash/"* "$SHARE_DIR/"
    fi
    
    # Copy config files if they exist
    if [ -d "${INSTALL_DIR}/config" ]; then
        cp -r "${INSTALL_DIR}/config/"* "$CONFIG_DIR/"
    fi
    
    print_msg success "Resources installed to $SHARE_DIR"
}

# Setup environment
setup_environment() {
    print_msg info "Setting up environment..."
    
    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
        print_msg warn "Add the following to your shell rc file:"
        echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
    fi
    
    print_msg success "Environment setup complete"
}

# Main installation
main() {
    echo ""
    print_msg info "Starting Wallbash installation..."
    echo ""
    
    check_dependencies
    create_directories
    install_scripts
    install_resources
    setup_environment
    
    echo ""
    print_msg success "Wallbash installed successfully!"
    echo ""
    print_msg info "Usage: wallbash /path/to/wallpaper.jpg"
    print_msg info "See README.md for more information"
    echo ""
}

# Run installation
main "$@"
