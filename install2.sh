#!/bin/bash

#echo "Shyciii user létrehozása"
#useradd -m -g users -G audio,video,network,wheel,storage -s /bin/bash shyciii
#echo "Shyciii jelszava:"
#passwd shyciii
pacman -S --noconfirm xorg-server xorg-xinit xterm
chown shyciii:users /mnt/home/Data
fallocate -l 4096M /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
sudo pacman -S --noconfirm xclip unrar curlftpfs fzf mediainfo bspwm sxhkd exa i3lock neovim xautolock awesome-terminal-fonts pulseaudio gpicview-gtk3 libreoffice-fresh transmission-gtk bind-tools wget traceroute gnome-calculator bash-completion intel-media-driver vifm ttf-roboto ttf-ubuntu-font-family pacman-contrib blueberry pcmanfm neofetch mpv chromium grsync htop git gimp ntfs-3g gnome-disk-utility android-tools gvfs udiskie rofi caprine
systemctl --user enable pulseaudio
sudo pacman -S --noconfirm pavucontrol
systemctl enable bluetooth.service
systemctl start bluetooth.service
Rfkill unblock bluetooth
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
trizen -S --noconfirm fuse-zip jmtpfs ttf-ms-fonts polybar split2flac-git subversion sacd-extract inxi downgrade
cd /home/Data/Linux/Compile/st-0.8.2
make clean install


