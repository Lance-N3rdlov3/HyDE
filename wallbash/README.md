# Wallbash - Standalone Wallpaper-based Color Theming System

Wallbash is a dynamic theming system that generates color schemes from wallpaper images and applies them across your desktop environment.

## Features

- **Automatic Color Extraction**: Generates color palettes from wallpaper images
- **Multi-Application Support**: Themes Hyprland, GTK, Qt, Kvantum, Kitty, Rofi, Waybar, and more
- **Multiple Color Profiles**: Default, vibrant, pastel, and mono color schemes
- **Independent Operation**: Works standalone without requiring the full HyDE environment

## Dependencies

### Required Packages
- `imagemagick` - Image processing and color extraction
- `parallel` - Parallel processing for faster theming
- `jq` - JSON processing

### Optional (for specific features)
- `hyprland` - For Hyprland theming
- `kitty` - For terminal theming
- `rofi` - For launcher theming
- `waybar` - For status bar theming
- `dunst` - For notification theming
- `kvantum` - For Qt theming

## Installation

### Quick Install
```bash
# Clone or download wallbash
git clone <repository-url> wallbash
cd wallbash

# Run the installer
./install.sh
```

### Manual Installation
```bash
# Copy scripts to local bin
mkdir -p ~/.local/bin
cp -r bin/* ~/.local/bin/

# Copy configuration templates
mkdir -p ~/.local/share/wallbash
cp -r share/wallbash/* ~/.local/share/wallbash/

# Copy application configs
mkdir -p ~/.config
cp -r config/* ~/.config/

# Make scripts executable
chmod +x ~/.local/bin/wallbash*
```

## Usage

### Basic Usage
```bash
# Generate colors from wallpaper and apply theme
wallbash /path/to/wallpaper.jpg

# Use specific color profile
wallbash --vibrant /path/to/wallpaper.jpg
wallbash --pastel /path/to/wallpaper.jpg
wallbash --mono /path/to/wallpaper.jpg

# Dark or light mode
wallbash --dark /path/to/wallpaper.jpg
wallbash --light /path/to/wallpaper.jpg
```

### Advanced Options
```bash
# Custom color curve (9 points: lightness saturation pairs)
wallbash --custom "10 99\n20 80\n30 70\n40 60\n50 50\n60 40\n70 30\n80 20\n90 10" /path/to/wallpaper.jpg

# Toggle wallbash on/off
wallbash-toggle

# Print current colors
wallbash-print-colors
```

## Color Profiles

- **default**: Balanced colors suitable for most wallpapers
- **vibrant**: High saturation, bold colors
- **pastel**: Soft, muted colors
- **mono**: Monochrome/grayscale theme

## File Structure

```
wallbash/
├── bin/                    # Executable scripts
│   ├── wallbash           # Main wallbash script
│   ├── wallbash-toggle    # Toggle wallbash theming
│   ├── wallbash-print     # Print current colors
│   └── color-set          # Color generation engine
├── share/wallbash/        # Shared resources
│   ├── scripts/           # Application-specific theme scripts
│   ├── theme/             # Color template files
│   └── always/            # Always-applied templates
└── config/                # Default configuration files
```

## Configuration

Wallbash stores its configuration and generated colors in:
- `~/.config/wallbash/` - User configuration
- `~/.local/share/wallbash/` - Theme templates and scripts
- `~/.cache/wallbash/` - Generated color files and cache

## Supported Applications

- **Hyprland**: Window decorations, borders, shadows
- **GTK 2/3/4**: GTK application themes
- **Qt5/Qt6**: Qt application themes via Kvantum
- **Kitty**: Terminal colors
- **Rofi**: Application launcher theme
- **Waybar**: Status bar theme
- **Dunst**: Notification colors
- **Vim**: Editor color scheme

## Environment Variables

- `WALLBASH_MODE`: Current theme mode (dark/light)
- `WALLBASH_PROFILE`: Current color profile
- `dcol_pry1-4`: Primary colors (hex)
- `dcol_txt1-4`: Text colors (hex)

## Troubleshooting

### Colors not applying
1. Ensure all dependencies are installed
2. Check permissions on config directories
3. Try reloading applications or restarting session

### ImageMagick errors
Update ImageMagick policy at `/etc/ImageMagick-7/policy.xml` to allow image processing

## License

See LICENSE file for details.

## Credits

Based on the wallbash system from the HyDE Project.
