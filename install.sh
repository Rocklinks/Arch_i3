#!/bin/bash
#Check if yay is installed
if ! command -v yay &> /dev/null; then
    sudo pacman -S yay
fi

# Function to check and add chaotic-aur repo
if ! grep -q "chaotic-aur" /etc/pacman.conf; then
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key 3056513887B78AEB
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
    sudo pacman -Syu --noconfirm 
fi

sudo pacman -S --noconfirm xfce4-panel xfdesktop xfce4-settings xfce4-power-manager xfce4-docklike-plugin bc openbox obconf playerctl picom parcellite numlockx rofi polybar lxappearance betterlockscreen zsh zsh-syntax-highlighting zsh-autosuggestions zsh-history-substring-search zsh-completions

sudo cp cache/* $HOME/.cache/ -rf
sudo cp udev/rules.d/90-backlight.rules /etc/udev/rules.d/

sudo cp usr/bin/networkmanager_dmenu /usr/bin/
cd chmod +x /usr/bin/networkmanager_dmenu


sudo cp config/* $HOME/.config/ -rf 
sudo chmod +x $HOME/.config/polybar/scripts/*

mkdir -p Fonts
tar -xzvf Fonts.tar.gz -C Fonts
sudo mv -R Fonts/* /usr/share/fonts/ 
sudo fc-cache -fv

mkdir -p zsh
tar -xzvf zsh.tar.gz -C zsh
sudo cp zsh/.bashrc $HOME
sudo cp zsh/.zshrc $HOME

sudo chown root:$(id -gn) $HOME/.cache/betterlockscreen
sudo chmod 750 $HOME/.cache/betterlockscreen

###  Permission to write to .config folder ##
sudo chown -R $(id -gn):root "$HOME/.config"
chmod -R 770 "$HOME/.config"

### Wifi ###
CONFIG="$HOME/.config/polybar/system.ini"
WIFI=$(ip link | awk '/state UP/ {print $2}' | tr -d :)
sed -i "s/sys_network_interface = wlan0/sys_network_interface = $WIFI/" "$CONFIG"
brightness=$(ls -1 /sys/class/backlight/)
sed -i "s/sys_graphics_card = intel_backlight/sys_graphics_card = $brightness/" "$CONFIG"

echo "Icons & themes are optional you can use your own"
echo "Use lxappearance for cursor theme change and settings-manager for gtk and icon themes"


