#!/bin/bash

# Compile using all cores
set -e
numberofcores=$(grep -c ^processor /proc/cpuinfo)
case $numberofcores in
    16)
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j17"/g' /etc/makepkg.conf
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 16 -z -)/g' /etc/makepkg.conf
        ;;
    8)
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j9"/g' /etc/makepkg.conf
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 8 -z -)/g' /etc/makepkg.conf
        ;;
    6)
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j7"/g' /etc/makepkg.conf
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 6 -z -)/g' /etc/makepkg.conf
        ;;       
    4)
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j5"/g' /etc/makepkg.conf
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 4 -z -)/g' /etc/makepkg.conf
        ;;
    2)
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j3"/g' /etc/makepkg.conf
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 2 -z -)/g' /etc/makepkg.conf
        ;;
    *)
        echo "We do not know how many cores you have."
        echo "Do it manually."
        ;;
esac
# Egyeb
sudo chown shyciii:users /home/Data
# Sound, Bluetooth
systemctl enable bluetooth.service
systemctl start bluetooth.service
rfkill unblock bluetooth
systemctl --user enable pulseaudio
pulseaudio --start
sudo systemctl restart bluetooth
# Install programs
sudo pacman -S --noconfirm xclip unrar curlftpfs fzf git mediainfo bspwm sxhkd exa i3lock neovim xautolock dunst gpicview-gtk3 libreoffice-fresh-hu transmission-gtk gnome-calculator vifm blueberry pcmanfm neofetch mpv chromium grsync htop gimp gnome-disk-utility sshfs rofi caprine
# Yay install
cd /home/shyciii
#git clone https://aur.archlinux.org/trizen.git
#cd trizen
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
#rm -rf /home/shyciii/trizen
rm -rf /home/shyciii/yay
# Install AUR programs
#trizen -S -v --noconfirm fuse-zip jmtpfs polybar split2flac-git subversion sacd-extract inxi downgrade
yay -Syyu --noconfirm --sudoloop fuse-zip jmtpfs polybar split2flac-git subversion sacd-extract inxi downgrade
# Install Suckless Terminal
cd /home/Data/Linux/Compile/st-0.8.2
sudo make clean install
# Remove orphans packages
sudo pacman -Rns --noconfirm $(pacman -Qtdq)
yay -Rsn --noconfirm --sudoloop go
# Copy own config
sudo mkdir /etc/pacman.d/hooks
sudo cp /home/Data/Linux/Backup/etc/pacman.d/hooks/clean_package_cache.hook /etc/pacman.d/hooks/clean_package_cache.hook
sudo cp -rv /home/Data/Linux/Backup/etc/sysctl.d/* /etc/sysctl.d/
sudo cp -rfv /home/Data/Linux/Backup/etc/systemd/* /etc/systemd/
sudo cp -rv /home/Data/Linux/Backup/usr/share/themes/* /usr/share/themes/
cp -rfv /home/Data/Linux/Backup/home/.config/* /home/shyciii/.config
cp -rfv /home/Data/Linux/Backup/home/.local/ /home/shyciii/
cp -rfv /home/Data/Linux/Backup/home/.grsync/ /home/shyciii/
mkdir /home/shyciii/mtp && mkdir /home/shyciii/mtp/android && mkdir /home/shyciii/mtp/ftp && mkdir /home/shyciii/mtp/ssh
cp -rfv /home/Data/Linux/Backup/home/Pictures /home/shyciii/
cp -fv /home/Data/Linux/Backup/home/.b* /home/Data/Linux/Backup/home/.gt* /home/Data/Linux/Backup/home/.x* /home/shyciii/
sudo cp -fv /home/Data/Linux/Arch_egyeb/mousepad_double_tap/etc/X11/xorg.conf.d/* /etc/X11/xorg.conf.d/
sudo chown -R shyciii:users /home/shyciii/
# Céges VPN beállítása
sudo nmcli connection import type openvpn file /home/Data/_TMVPN/TelemediaOVPN.ovpn
cd .. && sudo rm -rf /home/archlinux
