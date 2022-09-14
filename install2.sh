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

# Időzóna és ntp szerver beállítása
sudo timedatectl set-timezone Europe/Budapest
sudo timedatectl set-ntp true

# Bluetooth és Hang üzembehelyezése
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
rfkill unblock bluetooth
systemctl --user enable pulseaudio
pulseaudio --start
sudo bash -c "echo AutoEnable=true >> /etc/bluetooth/main.conf"
sudo systemctl restart bluetooth

# Heti fstrim futtatásának engedélyezése (SSD Trim funkció)
systemctl enable fstrim.timer
systemctl start fstrim.timer

# Programok telepítése hivatalos repóból
sudo pacman -Sy --noconfirm fd imagemagick imv trash-cli xclip fuse-zip zip unzip unrar curlftpfs fzf mediainfo ueberzug bspwm sxhkd exa i3lock xautolock dunst libreoffice-fresh-hu transmission-gtk gnome-calculator vifm neofetch mpv grsync htop sshfs rofi subversion

# Yay telepítése
cd /home/shyciii
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
rm -rf /home/shyciii/yay

# Programok telepítése AUR-ból
yay -Syu --noconfirm --sudoloop go-mtpfs-git archivemount ttf-oswald google-chrome polybar split2flac sacd-extract inxi-git downgrade micro

# Suckless Terminal telepítése
cd /home/Data/Linux/Compile/st-0.8.4
sudo make clean install

# USB Driveok automountja
cd /home/Data/Linux/Compile/automount-usb
sudo sh configure.sh

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

# Naplózás beállítása
sudo bash -c "echo MaxRetentionSec=15day >> /etc/systemd/journald.conf"

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

#Notebook fedelének történéseinek beállítása
sudo sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
sudo sed -i 's/#HandleLidSwitchExternalPower=suspend/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf
sudo sed -i 's/#HandleLidSwitchDocked=ignore/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf

# Data könyvtár tulajdonosának beállítása
sudo chown shyciii:users /home/Data

# Saját config fileok visszaállítása
sudo cp -rv /home/Data/Linux/Backup/etc/issue /etc/issue
mkdir -p /home/shyciii/mnt/android /home/shyciii/mnt/ftp /home/shyciii/mnt/ssh
tar -xvf /home/Data/Linux/Backup/home_backup.tar.zst --directory /home/shyciii
sudo rm -rf /home/shyciii/go

# Home könyvtár tulajdonosának visszaállítása
sudo chown -R shyciii:users /home/shyciii/

cd .. && sudo rm -rf /home/archlinux
