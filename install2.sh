#!/bin/bash

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
echo "################################################################"
echo "###  All cores will be used during building and compression ####"
echo "################################################################"
sudo pacman -S --noconfirm xorg-server xorg-xinit xterm
chown shyciii:users /home/Data
fallocate -l 4096M /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
sudo pacman -S --noconfirm xclip unrar curlftpfs fzf mediainfo bspwm sxhkd exa i3lock neovim xautolock awesome-terminal-fonts pulseaudio gpicview-gtk3 libreoffice-fresh transmission-gtk bind-tools wget traceroute gnome-calculator bash-completion intel-media-driver vifm ttf-roboto ttf-ubuntu-font-family pacman-contrib blueberry pcmanfm neofetch mpv chromium grsync htop git gimp ntfs-3g gnome-disk-utility android-tools gvfs udiskie rofi caprine
systemctl --user enable pulseaudio
sudo pacman -S --noconfirm pavucontrol
systemctl enable bluetooth.service
systemctl start bluetooth.service
rfkill unblock bluetooth
sudo pacman -S --noconfirm pulseaudio-bluetooth
sudo killall pulseaudio
pulseaudio --start
sudo systemctl restart bluetooth
sudo usermod -a -G rfkill shyciii
cd /home/shyciii
git clone https://aur.archlinux.org/trizen.git
cd trizen
makepkg -si
cd ..
rm -rf /home/shyciii/trizen
sudo pacman -Syyu
cd /home/shyciii
git clone https://aur.archlinux.org/trizen.git
cd trizen
makepkg -si
cd ..
rm -rf /home/shyciii/trizen
sudo pacman -Syyu
trizen -S --noconfirm fuse-zip jmtpfs polybar split2flac-git subversion sacd-extract inxi downgrade
cd /home/Data/Linux/Compile/st-0.8.2
make clean install
sudo mkdir /etc/pacman.d/hooks
sudo cp /home/Data/Linux/Backup/etc/pacman.d/hooks/clean_package_cache.hook /etc/pacman.d/hooks/clean_package_cache.hook
sudo cp /home/Data/Linux/Backup/usr/share/themes/ /usr/share/themes/
