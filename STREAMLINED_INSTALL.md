# HyDE Streamlined Installation Guide

This guide covers the new streamlined installation process for HyDE, optimized for speed and simplicity.

## Overview

The streamlined installer consolidates multiple installation scripts into a single optimized workflow that:
- Installs Hyprland and essential packages
- Automatically sets up Chaotic AUR for faster package availability
- Installs yay-bin as the default AUR helper
- Configures zsh as the default shell
- Installs all available themes
- Uses sensible defaults to minimize user interaction

## Quick Start

### Standard Streamlined Installation

```bash
pacman -S --needed git base-devel
git clone --depth 1 https://github.com/HyDE-Project/HyDE ~/HyDE
cd ~/HyDE/Scripts
./install_streamlined.sh
```

### Minimal Installation (Fastest)

For the absolute fastest installation with only essential packages:

```bash
cd ~/HyDE/Scripts
./install_streamlined.sh -m
```

This installs only 37 core packages instead of the full 88-package set.

## Options

```
Usage: ./install_streamlined.sh [options]

Options:
    -n    Skip NVIDIA configuration (if you don't have NVIDIA GPU)
    -m    Use minimal package list (37 packages, fastest installation)
    -t    Test/dry-run mode (no actual installation)
    -h    Show help message
```

### Examples

```bash
# Standard streamlined installation
./install_streamlined.sh

# Minimal installation without NVIDIA
./install_streamlined.sh -m -n

# Test run to see what would be installed
./install_streamlined.sh -t

# Minimal test run
./install_streamlined.sh -m -t
```

## What Gets Installed

### Standard Mode (pkg_core.lst)
- **System**: 88 packages including Hyprland, Wayland, audio/video
- **Applications**: Firefox, Kitty, Dolphin, VS Code
- **Themes**: All available HyDE themes
- **Tools**: Development tools, system utilities

### Minimal Mode (-m flag, pkg_minimal.lst)
- **System**: 37 essential packages
- **Core**: Hyprland, SDDM, basic Wayland components
- **Minimal Apps**: Kitty terminal, Dolphin file manager
- **Themes**: All available HyDE themes (same as standard)

## Installation Flow

1. **Chaotic AUR Setup**
   - Automatically installs and configures Chaotic AUR
   - Provides pre-compiled packages for faster installation
   - No user interaction required

2. **Pacman Configuration**
   - Enables parallel downloads (5 concurrent)
   - Enables color output and progress bars
   - Enables multilib repository

3. **AUR Helper Installation**
   - Installs yay-bin by default
   - No selection prompt (uses sensible default)

4. **Package Installation**
   - Installs from chosen package list (core or minimal)
   - Auto-detects and installs NVIDIA drivers if GPU detected
   - Installs zsh as default shell

5. **Configuration Restore**
   - Restores fonts
   - Restores HyDE configurations
   - Installs all available themes

6. **Post-Installation**
   - Generates wallpaper cache
   - Enables system services
   - Configures shell
   - Runs latest migration if needed

## Comparison with Original Installer

### Original Installation (`install.sh`)
- Multiple scripts: `install.sh`, `install_pre.sh`, `install_pkg.sh`, `install_aur.sh`, `install_pst.sh`
- Total: 709 lines of code across 5 files
- Multiple user prompts for:
  - AUR helper selection (yay/paru)
  - Shell selection (zsh/fish)
  - Chaotic AUR installation
  - GRUB theme selection
  - SDDM theme selection
  - Flatpak installation

### Streamlined Installation (`install_streamlined.sh`)
- Single script: 286 lines (60% reduction)
- Sensible defaults:
  - yay-bin (faster than yay)
  - zsh (most popular)
  - Chaotic AUR (enabled by default)
  - All themes installed
- Minimal user interaction
- Faster execution time

## Post-Installation

After installation completes:

1. **Reboot**: Highly recommended to apply all changes
2. **Login**: Use SDDM display manager
3. **Theme Selection**: Use `Super + Ctrl + T` to select themes
4. **Wallpaper**: Use `Super + Shift + W` to change wallpaper

## Wallbash Standalone

Wallbash has been extracted as a standalone application. See `wallbash/README.md` for details.

To use wallbash independently:

```bash
cd ~/HyDE/wallbash
./install.sh

# Then use it
wallbash /path/to/wallpaper.jpg
wallbash --vibrant ~/Pictures/sunset.png
```

## Troubleshooting

### Installation fails at package installation
- Check internet connection
- Ensure Chaotic AUR is properly configured: `grep chaotic-aur /etc/pacman.conf`
- Try manual package installation: `sudo pacman -Sy`

### NVIDIA drivers not installing
- Use `-n` flag to skip NVIDIA if you don't have NVIDIA GPU
- Check if your GPU is supported: `lspci | grep VGA`

### Want more packages
- Use the original installer: `./install.sh`
- Or install extras after: `./install.sh pkg_extra.lst`

## Advanced Usage

### Custom Package Lists

Create your own package list:

```bash
cp Scripts/pkg_minimal.lst Scripts/pkg_custom.lst
# Edit pkg_custom.lst to add/remove packages
# Then modify install_streamlined.sh to use it
```

### Skip Specific Steps

Edit `install_streamlined.sh` and comment out sections you don't need.

## Support

For issues or questions:
- Check the [main README](../README.md)
- Visit the [HyDE Wiki](https://hydeproject.pages.dev/)
- Join the [Discord](https://discord.gg/qWehcFJxPa)

## Contributing

See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.
