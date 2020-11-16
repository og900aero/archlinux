#!/bin/bash

# Processzormagok számának beállítása programok, csomagok fordításához
set -e
numberofcores=$(grep -c ^processor /proc/cpuinfo)

if [ $numberofcores -gt 1 ]
then
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j'$(($numberofcores+1))'"/g' /etc/makepkg.conf;
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T '"$numberofcores"' -z -)/g' /etc/makepkg.conf
else
        echo "No change."
fi

sleep 5

# Data köbyvtár tulajdonosának beállítása
sudo chown shyciii:users /home/Data

sleep 5

# Bluetooth és Hang üzembehelyezése
systemctl enable bluetooth.service
systemctl start bluetooth.service
rfkill unblock bluetooth
systemctl --user enable pulseaudio
pulseaudio --start
sudo systemctl restart bluetooth

sleep 5

# Programok telepítése hivatalos repóból
sudo pacman -Sy --noconfirm xclip unrar curlftpfs fzf git mediainfo ueberzug bspwm sxhkd exa i3lock xautolock dunst feh libreoffice-fresh-hu transmission-gtk gnome-calculator vifm blueberry pcmanfm neofetch mpv chromium grsync htop gnome-disk-utility sshfs rofi caprine

sleep 5

# Yay telepítése
cd /home/shyciii
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
rm -rf /home/shyciii/yay

sleep 5

# Programok telepítése AUR-ból
yay -Syyu --noconfirm --sudoloop fuse-zip polybar split2flac-git subversion sacd-extract inxi downgrade micro

sleep 5

# Suckless Terminal telepítése
cd /home/Data/Linux/Compile/st-0.8.4
sudo make clean install

sleep 5

# Használaton kívűli csomagok eltávolítása
sudo pacman -Rns --noconfirm $(pacman -Qtdq)

sleep 5

# Package cache futtatása minden telepítés és upgrade után
sudo mkdir -p /etc/pacman.d/hooks
sudo cat <<EOF > /etc/pacman.d/hooks/clean_package_cache.hook
[Trigger]
Operation = Upgrade
Operation = Install
Operation = Remove
Type = Package
Target = *
[Action]
Description = Cleaning pacman cache...
When = PostTransaction
Exec = /usr/bin/paccache -r
EOF

sleep 5

# Swap használatának beállítása
sudo echo "vm.swappiness=30" > /etc/sysctl.d/99-sysctl.conf

sleep 5

# Android Oneplus udev szabály
sudo echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="2a70", ATTR{idProduct}=="9011", MODE="0660", GROUP="uucp", ENV{ID_MTP_DEVICE}="1", SYMLINK+="libmtp"' > /etc/udev/rules.d/51-android.rules

sleep 5

# Login felirat módosítása
sudo cat <<EOF > /etc/issue
\e[H\e[2J
                                                  \e[1;30m| \e[34m\r \s
                      \e[37m||      \e[37m| =                 \e[30m|
                      \e[37m||      \e[37m|                   \e[30m| \e[32m\t
   \e[37m//==\\\\\\ ||/= /==\\\\ ||/=\\\\  \e[37m| | |/\\\\ |  | \\\\ /  \e[30m| \e[32m\d
  \e[37m||    || ||  ||     ||  ||  \e[37m| | |  | |  |   X   \e[1;30m|
   \e[37m\\\\\\==/| ||   \\\\==/ ||  ||  \e[37m| | |  |\  \\/|  / \\\\ \e[1;30m| \e[31m\U
                                                  \e[1;30m|
                                                  \e[1;30m| \e[35m\l \e[0mon \e[1;33m\n
\e[0m
EOF

sleep 5

# Notebook-hoz doube tap beállítása
sudo cat <<EOF > /etc/X11/xorg.conf.d/40-libinput.conf
Section "InputClass"
        Identifier "libinput pointer catchall"
        MatchIsPointer "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
EndSection

Section "InputClass"
        Identifier "libinput keyboard catchall"
        MatchIsKeyboard "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
EndSection

Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        Option "Tapping" "on"
        Option "TappingButtonMap" "lmr"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
EndSection

Section "InputClass"
        Identifier "libinput touchscreen catchall"
        MatchIsTouchscreen "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
EndSection

Section "InputClass"
        Identifier "libinput tablet catchall"
        MatchIsTablet "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
EndSection
EOF

sleep 5

# Timeout beállítása
sed -i 's/#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=5s/' /etc/systemd/system.conf

sleep 5

# Saját config fileok visszaállítása
sudo cp -rv /home/Data/Linux/Backup/usr/share/themes/* /usr/share/themes/
cp -rfv /home/Data/Linux/Backup/home/.config/* /home/shyciii/.config
cp -rfv /home/Data/Linux/Backup/home/.local/ /home/shyciii/
cp -rfv /home/Data/Linux/Backup/home/.grsync/ /home/shyciii/
mkdir /home/shyciii/mtp && mkdir /home/shyciii/mtp/android && mkdir /home/shyciii/mtp/ftp && mkdir /home/shyciii/mtp/ssh
cp -rfv /home/Data/Linux/Backup/home/Pictures /home/shyciii/
cp -fv /home/Data/Linux/Backup/home/.b* /home/Data/Linux/Backup/home/.gt* /home/Data/Linux/Backup/home/.x* /home/shyciii/

sleep 5

# Home könyvtár tulajdonosának visszaállítása
sudo chown -R shyciii:users /home/shyciii/

sleep 5

# Céges VPN beállítása
sudo nmcli connection import type openvpn file /home/Data/_TMVPN/TelemediaOVPN.ovpn
cd .. && sudo rm -rf /home/archlinux
