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
# Xorg
sudo pacman -S --noconfirm xorg-server xorg-xinit xorg-fonts-encoding xorg-mkfontscale xterm mesa xf86-video-intel
# Egyeb
sudo chown shyciii:users /home/Data
# Sound, Bluetooth
sudo pacman -S --noconfirm pulseaudio pavucontrol pulseaudio-bluetooth
systemctl enable bluetooth.service
systemctl start bluetooth.service
rfkill unblock bluetooth
systemctl --user enable pulseaudio
pulseaudio --start
sudo systemctl restart bluetooth
# Custom programs, fonts etc
sudo pacman -S --noconfirm xdg-user-dirs xclip unrar curlftpfs fzf mediainfo bspwm sxhkd exa i3lock neovim xautolock dunst awesome-terminal-fonts gpicview-gtk3 libreoffice-fresh-hu transmission-gtk bind-tools wget traceroute gnome-calculator bash-completion intel-media-driver vifm ttf-roboto ttf-ubuntu-font-family pacman-contrib blueberry pcmanfm neofetch mpv chromium grsync htop git gimp ntfs-3g gnome-disk-utility android-tools gnome-keyring ttf-dejavu reflector polkit-gnome sshfs gvfs udiskie rofi caprine
# Trizen install
cd /home/shyciii
git clone https://aur.archlinux.org/trizen.git
cd trizen
makepkg -si
rm -rf /home/shyciii/trizen
sudo pacman -Syyu
# Install AUR programs
trizen -S --noconfirm fuse-zip jmtpfs polybar split2flac-git subversion sacd-extract inxi downgrade
# Install Suckless Terminal
cd /home/Data/Linux/Compile/st-0.8.2
sudo make clean install
# Copy own config
sudo mkdir /etc/pacman.d/hooks
sudo cp /home/Data/Linux/Backup/etc/pacman.d/hooks/clean_package_cache.hook /etc/pacman.d/hooks/clean_package_cache.hook
sudo cp -rv /home/Data/Linux/Backup/etc/sysctl.d/* /etc/sysctl.d/
sudo cp -rfv /home/Data/Linux/Backup/etc/systemd/* /etc/systemd/
sudo cp -rv /home/Data/Linux/Backup/usr/share/themes/* /usr/share/themes/
sudo cp -rfv /home/Data/Linux/Backup/home/.config/* /home/shyciii/.config
sudo cp -rfv /home/Data/Linux/Backup/home/.local/ /home/shyciii/
sudo cp -rfv /home/Data/Linux/Backup/home/.grsync/ /home/shyciii/
sudo cp -rfv /home/Data/Linux/Backup/home/mnt /home/shyciii/
sudo cp -rfv /home/Data/Linux/Backup/home/Pictures /home/shyciii/
sudo cp -fv /home/Data/Linux/Backup/home/.b* /home/Data/Linux/Backup/home/.g* /home/Data/Linux/Backup/home/.x* /home/shyciii/
sudo cp -fv /home/Data/Linux/Arch_egyeb/mousepad_double_tap/etc/X11/xorg.conf.d/* /etc/X11/xorg.conf.d/
sudo chown -R shyciii:users /home/shyciii
