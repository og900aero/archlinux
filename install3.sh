#!/bin/bash

# Swap file
sudo dd if=/dev/zero of=/swapfile bs=1M count=2048 status=progress
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo echo "/swapfile   none  swap  defaults,discard  0	0" >> /etc/fstab
# User
echo "Shyciii user létrehozása"
useradd -m -g users -G audio,video,network,wheel,storage,rfkill shyciii
echo "Shyciii jelszava:"
passwd shyciii
EDITOR=nvim visudo
# Xorg
sudo pacman -S --noconfirm xorg-server xorg-xinit xorg-fonts-encodings xorg-mkfontscale xterm mesa xf86-video-intel
# Install fonts, home dirs etc
#sudo pacman -S --noconfirm xdg-user-dirs git bind-tools wget traceroute man-db man-pages intel-media-driver pacman-contrib bash-completion android-tools gvfs udiskie awesome-terminal-fonts ttf-ubuntu-font-family ttf-roboto ttf-dejavu git ntfs-3g gnome-keyring reflector polkit-gnome
# Install Sound
sudo pacman -S --noconfirm pulseaudio pavucontrol pulseaudio-bluetooth
echo "############################################################################"
echo "Reboot, majd shyciii felhasználóval lépj be, és mehet az Install4.sh script."
echo "############################################################################"
