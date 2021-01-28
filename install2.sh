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

# Data köbyvtár tulajdonosának beállítása
sudo chown shyciii:users /home/Data

# Bluetooth és Hang üzembehelyezése
systemctl enable bluetooth.service
systemctl start bluetooth.service
rfkill unblock bluetooth
systemctl --user enable pulseaudio
pulseaudio --start
sudo systemctl restart bluetooth
sudo bash -c "echo AutoEnable=true >> /etc/bluetooth/main.conf"

# Heti fstrim futtatásának engedélyezése (SSD Trim funkció)
systemctl start fstrim.service

# Programok telepítése hivatalos repóból
sudo pacman -Sy --noconfirm fd imagemagick imv trash-cli xclip fuse-zip zip unzip unrar curlftpfs fzf mediainfo ueberzug bspwm sxhkd exa i3lock xautolock dunst libreoffice-fresh-hu transmission-gtk gnome-calculator vifm neofetch mpv chromium grsync htop sshfs rofi caprine

# Yay telepítése
cd /home/shyciii
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
rm -rf /home/shyciii/yay

# Programok telepítése AUR-ból
yay -Syu --noconfirm --sudoloop go-mtpfs-git archivemount polybar split2flac-git subversion sacd-extract inxi downgrade micro

# Suckless Terminal telepítése
cd /home/Data/Linux/Compile/st-0.8.4
sudo make clean install

# USB Driveok automountja
sudo sh /home/Data/Linux/Compile/automount-usb/configure.sh

# Használaton kívűli csomagok eltávolítása
sudo pacman -Rns --noconfirm $(pacman -Qtdq)

# Package cache futtatása minden telepítés és upgrade után
sudo mkdir -p /etc/pacman.d/hooks
sudo bash -c "cat > /etc/pacman.d/hooks/clean_package_cache.hook" <<EOF
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

# Swap használatának beállítása
sudo bash -c "echo vm.swappiness=10 > /etc/sysctl.d/99-sysctl.conf"

# Notebook-hoz doube tap beállítása
sudo bash -c "cat > /etc/X11/xorg.conf.d/40-libinput.conf" <<EOF
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

# Timeout beállítása
sudo sed -i 's/#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=10s/' /etc/systemd/system.conf

# Saját config fileok visszaállítása
sudo cp -rv /home/Data/Linux/Backup/usr/share/themes/* /usr/share/themes/
sudo cp -rv /home/Data/Linux/Backup/etc/issue /etc/issue
atool -fvX ~/ /home/Data/Linux/Backup/home_backup.tar.gz
cp -rfv /home/Data/Linux/Backup/home/.local/ /home/shyciii/
mkdir -p /home/shyciii/mnt/android /home/shyciii/mnt/ftp /home/shyciii/mnt/ssh
#cp -rfv /home/Data/Linux/Backup/home/.config/* /home/shyciii/.config
#cp -rfv /home/Data/Linux/Backup/home/.grsync/ /home/shyciii/
#cp -rfv /home/Data/Linux/Backup/home/Pictures /home/shyciii/
#cp -fv /home/Data/Linux/Backup/home/.b* /home/Data/Linux/Backup/home/.gt* /home/Data/Linux/Backup/home/.x* /home/shyciii/
sudo rm -rf /home/shyciii/go

# Home könyvtár tulajdonosának visszaállítása
sudo chown -R shyciii:users /home/shyciii/

# Céges VPN beállítása
sudo nmcli connection import type openvpn file /home/Data/_TMVPN/TelemediaOVPN.ovpn
cd .. && sudo rm -rf /home/archlinux
