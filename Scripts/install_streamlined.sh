#!/usr/bin/env bash
#|---/ /+------------------------------------------+---/ /|#
#|--/ /-| Streamlined HyDE Installation Script    |--/ /-|#
#|-/ /--| Optimized for speed and simplicity      |-/ /--|#
#|/ /---+------------------------------------------+/ /---|#

cat <<"EOF"

-------------------------------------------------
        .
       / \         _       _  _      ___  ___
      /^  \      _| |_    | || |_  _|   \| __|
     /  _  \    |_   _|   | __ | || | |) | _|
    /  | | ~\     |_|     |_||_|\_, |___/|___|
   /.-'   '-.\                  |__/

      Streamlined Installation
-------------------------------------------------

EOF

#--------------------------------#
# import variables and functions #
#--------------------------------#
scrDir="$(dirname "$(realpath "$0")")"
if ! source "${scrDir}/global_fn.sh"; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi

#------------------#
# evaluate options #
#------------------#
export flg_Nvidia=1
export flg_DryRun=0
export use_default="--noconfirm"

while getopts nth RunStep; do
    case $RunStep in
    n)
        export flg_Nvidia=0
        print_log -r "[nvidia] " -b "Ignored :: " "skipping Nvidia actions"
        ;;
    t) 
        flg_DryRun=1
        print_log -n "[test-run] " -b "enabled :: " "Testing without executing"
        ;;
    h)
        cat <<EOF
Usage: $0 [options]
            n : ignore/[n]o [n]vidia actions
            t : [t]est run without executing
            h : show this [h]elp message

NOTE: This streamlined installer will:
      - Install Hyprland and core packages
      - Set up pacman wrapper (yay-bin by default)
      - Activate Chaotic AUR
      - Install keybindings
      - Install all available themes
      - Use sensible defaults (non-interactive)

EOF
        exit 0
        ;;
    *)
        echo "Invalid option. Use -h for help."
        exit 1
        ;;
    esac
done

HYDE_LOG="$(date +'%y%m%d_%Hh%Mm%Ss')"
export HYDE_LOG

#--------------------------#
# Install Chaotic AUR first #
#--------------------------#
cat <<"EOF"
     _           _   _        _   _ ___
 ___| |_ ___ ___| |_|_|___   |___|_|  _|
|  _|   | .'| . |  _| |  _|  | .'| |    |
|___|_|_|__,|___|_| |_|___|  |__,|_|_|__|

EOF

print_log -sec "CHAOTIC-AUR" -stat "Setting up" "Chaotic AUR repository"

if ! grep -q '\[chaotic-aur\]' /etc/pacman.conf; then
    if [ "${flg_DryRun}" -ne 1 ]; then
        sudo pacman-key --init
        sudo "${scrDir}/chaotic_aur.sh" --install fresh
    fi
    print_log -g "[CHAOTIC-AUR] " -stat "installed" "Chaotic AUR activated"
else
    print_log -y "[CHAOTIC-AUR] " -stat "skipped" "Chaotic AUR already configured"
fi

#--------------------#
# Configure pacman   #
#--------------------#
if [ -f /etc/pacman.conf ] && [ ! -f /etc/pacman.conf.hyde.bkp ]; then
    print_log -g "[PACMAN] " -b "modify :: " "configuring pacman..."
    
    if [ "${flg_DryRun}" -ne 1 ]; then
        sudo cp /etc/pacman.conf /etc/pacman.conf.hyde.bkp
        sudo sed -i "/^#Color/c\Color\nILoveCandy
        /^#VerbosePkgLists/c\VerbosePkgLists
        /^#ParallelDownloads/c\ParallelDownloads = 5" /etc/pacman.conf
        sudo sed -i '/^#\[multilib\]/,+1 s/^#//' /etc/pacman.conf
        sudo pacman -Syyu --noconfirm
        sudo pacman -Fy
    fi
else
    print_log -y "[PACMAN] " -stat "skipped" "pacman already configured"
fi

#--------------------#
# Install AUR Helper #
#--------------------#
cat <<"EOF"

 ___ _ _ ___    _        _
| .'| | |  _|  |_|___ ___| |_ ___ _ _ _
| | | | |    |  | |   |_ -|  _| .'| | |
|__,|___|_|  |_|_|_|_|___|_| |__,|_|_|_|

EOF

export getAur="yay-bin"
print_log -sec "AUR" -stat "Installing" "yay-bin as AUR helper"

if ! chk_list "aurhlpr" "${aurList[@]}"; then
    if [ "${flg_DryRun}" -ne 1 ]; then
        "${scrDir}/install_aur.sh" "${getAur}"
    fi
fi
chk_list "aurhlpr" "${aurList[@]}"

#----------------------#
# Prepare package list #
#----------------------#
cat <<"EOF"

 _         _       _ _ _
|_|___ ___| |_ ___| | |_|___ ___
| |   |_ -|  _| .'| | | |   | . |
|_|_|_|___|_| |__,|_|_|_|_|_|_  |
                            |___|

EOF

cp "${scrDir}/pkg_core.lst" "${scrDir}/install_pkg.lst"
trap 'mv "${scrDir}/install_pkg.lst" "${cacheDir}/logs/${HYDE_LOG}/install_pkg.lst"' EXIT

#--------------------------------#
# add nvidia drivers to the list #
#--------------------------------#
if nvidia_detect; then
    if [ ${flg_Nvidia} -eq 1 ]; then
        cat /usr/lib/modules/*/pkgbase | while read -r kernel; do
            echo "${kernel}-headers" >>"${scrDir}/install_pkg.lst"
        done
        nvidia_detect --drivers >>"${scrDir}/install_pkg.lst"
    fi
fi
nvidia_detect --verbose

#--------------#
# Install Shell #
#--------------#
export myShell="zsh"
print_log -sec "shell" -stat "Using default" "zsh"
echo "${myShell}" >>"${scrDir}/install_pkg.lst"

#--------------------------------#
# install packages from the list #
#--------------------------------#
print_log -sec "packages" -stat "Installing" "core packages..."
"${scrDir}/install_pkg.sh" "${scrDir}/install_pkg.lst"

#---------------------------#
# restore configs           #
#---------------------------#
cat <<"EOF"

             _           _
 ___ ___ ___| |_ ___ ___|_|___ ___
|  _| -_|_ -|  _| . |  _| |   | . |
|_| |___|___|_| |___|_| |_|_|_|_  |
                              |___|

EOF

if [ "${flg_DryRun}" -ne 1 ] && [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    hyprctl keyword misc:disable_autoreload 1 -q
fi

"${scrDir}/restore_fnt.sh"
"${scrDir}/restore_cfg.sh"

#---------------------------#
# Install all themes        #
#---------------------------#
export flg_ThemeInstall=1
"${scrDir}/restore_thm.sh"

print_log -g "[generate] " "cache ::" "Wallpapers..."
if [ "${flg_DryRun}" -ne 1 ]; then
    export PATH="$HOME/.local/lib/hyde:$HOME/.local/bin:${PATH}"
    "$HOME/.local/lib/hyde/swwwallcache.sh" -t "" || true
    "$HOME/.local/lib/hyde/theme.switch.sh" -q || true
    "$HOME/.local/lib/hyde/waybar.py" --update || true
fi

#------------------------#
# enable system services #
#------------------------#
cat <<"EOF"

             _
 ___ ___ _ _|_|___ ___ ___
|_ -| -_| | | |  _| -_|_ -|
|___|___|___|_|___|___|___|

EOF

"${scrDir}/restore_svc.sh"

#--------------------#
# Configure shell    #
#--------------------#
"${scrDir}/restore_shl.sh"

#------------------------#
# Run migrations         #
#------------------------#
migrationDir="${scrDir}/migrations"
if [ -d "${migrationDir}" ] && find "${migrationDir}" -type f | grep -q .; then
    migrationFile=$(find "${migrationDir}" -maxdepth 1 -type f -printf '%f\n' | sort -r | head -n 1)
    if [[ -n "${migrationFile}" && -f "${migrationDir}/${migrationFile}" ]]; then
        echo "Running migration: ${migrationFile}"
        sh "${migrationDir}/${migrationFile}"
    fi
fi

#------------------------#
# Completion             #
#------------------------#
echo ""
print_log -g "Installation" " :: " "COMPLETED!"
print_log -b "Log" " :: " -y "View logs at ${cacheDir}/logs/${HYDE_LOG}"

if [ "${flg_DryRun}" -ne 1 ]; then
    if [[ -z "${HYPRLAND_CONFIG:-}" ]] || [[ ! -f "${HYPRLAND_CONFIG}" ]]; then
        print_log -warn "Hyprland config not found! Might be a new install."
        print_log -warn "Please reboot the system to apply changes."
    fi

    print_log -stat "HyDE" "Reboot recommended. Reboot now? (y/N)"
    read -r answer
    
    if [[ "$answer" == [Yy] ]]; then
        echo "Rebooting system..."
        systemctl reboot
    else
        echo "Please reboot when ready to complete installation."
    fi
fi
