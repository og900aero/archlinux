#!/bin/bash

# Magyar billentyűzet
loadkeys hu

# A 10 legfrissebb magyar szerver beállítása
pacman -Sy --noconfirm reflector
reflector --verbose --latest 10 -c HU --save /etc/pacman.d/mirrorlist

# Idő szinkronizálás engedélyezése távoli idő kiszolgálóval
timedatectl set-ntp true

# Saját partíciók kezelése, beállítása
#cfdisk
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2

# Root felcsatolása
mount /dev/sda2 /mnt

# Boot szerkezet létrehozása, felcsatolása
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

# Alap rendszer telepítése
pacstrap /mnt base base-devel linux linux-firmware intel-ucode

# Saját Data könyvtár létrehozása, és felmountolása
mkdir -p /mnt/home/Data
mount /dev/sda3 /mnt/home/Data
chmod 744 /mnt/home/Data

# Fstab létrehozása, SSD.nek megfelelő értékekre cserélés
genfstab -U /mnt >> /mnt/etc/fstab
sed -i 's/rw/defaults/g' /mnt/etc/fstab

# UEFI és systemd-s bootolás beállítása + egyedi kapcsolók hozzáadása
arch-chroot /mnt bootctl --path=/boot install
cat <<EOF > /mnt/boot/loader/loader.conf
default arch
timeout 1
EOF
cat <<EOF > /mnt/boot/loader/entries/arch.conf
title    Arch Linux
linux    /vmlinuz-linux
initrd   /intel-ucode.img
initrd   /initramfs-linux.img
options  root=PARTUUID=$(blkid | grep sda2 | sed 's/\(.*\)PARTUUID="\(.*\)"$/\2/') rw quit i915.enable_guc=2 i915.enable_fbc=1 i915.fastboot=1 loglevel=3
EOF

# Magyar időzóna beállítása
ln -sf /mnt/usr/share/zoneinfo/Europe/Budapest /mnt/etc/localtime

# Hardver óra beállítása
arch-chroot /mnt hwclock --systohc

# Lokális nyelvezet beállítása angolra
echo "en_US.UTF-8 UTF-8" >> /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf

# Parancssori billentyűzet beállítása
echo KEYMAP=hu > /mnt/etc/vconsole.conf

# Hosts, hostname beállítása
echo "archlinux" > /mnt/etc/hostname
cat <<EOF > /mnt/etc/hosts
127.0.0.1	localhost
::1		localhost
127.0.1.1	archlinux.localdomain	archlinux
EOF

# Naplózás beállítása
echo "MaxRetentionSec=15day" >> /mnt/etc/systemd/journald.conf

# Hálózati komponensek telepítése
arch-chroot /mnt pacman -S --noconfirm networkmanager network-manager-applet networkmanager-openvpn

arch-chroot /mnt systemctl enable NetworkManager.service

# mkinitcpio manuális futtatás (initial ramdisk)
arch-chroot /mnt mkinitcpio -p linux

# Swap file létrehozása
arch-chroot /mnt dd if=/dev/zero of=/swapfile bs=1M count=2048 status=progress
arch-chroot /mnt chmod 600 /swapfile
arch-chroot /mnt mkswap /swapfile
arch-chroot /mnt swapon /swapfile
echo "/swapfile   none  swap  defaults  0	0" >> /mnt/etc/fstab

# Install Xorg, videó driverek
arch-chroot /mnt pacman -S --noconfirm xorg-server xorg-xinit xorg-fonts-encodings xorg-mkfontscale mesa xf86-video-intel intel-media-driver xf86-video-nouveau

# Magyar billentyű beállítása
cat <<EOF > /mnt/etc/X11/xorg.conf.d/00-keyboard.conf
Section "InputClass"
    Identifier "system-keyboard"
    MatchIsKeyboard "on"
    Option "XkbLayout" "hu"
    Option "XkbModel" "pc105"
    Option "XkbOptions" "terminate:ctrl_alt_bksp"
EndSection
EOF

# Intel driver beállítása
cat <<EOF > /mnt/etc/X11/xorg.conf.d/20-intel.conf
Section "Device"
    Identifier "Intel Graphics"
    Driver "intel"
    Option "AccelMethod" "sna"
    Option "TearFree" "true"
    Option "TripleBuffer" "true"
EndSection
EOF

# Install Sound and Bluetooth
arch-chroot /mnt pacman -S --noconfirm pulseaudio pavucontrol pulseaudio-bluetooth bluez

# Install fonts, home dirs etc
arch-chroot /mnt pacman -S --noconfirm libmtp xdg-user-dirs bind wget traceroute man-db man-pages pacman-contrib bash-completion android-tools awesome-terminal-fonts ttf-hack ttf-ubuntu-font-family ttf-roboto ttf-dejavu git ntfs-3g gnome-keyring reflector polkit-gnome

# Root jelszó beállítása
echo "Root jelszava:"
arch-chroot /mnt passwd root

# Felhasználó létrehozása, csoportokhoz hozzáadása, jelszó létrehozása
arch-chroot /mnt useradd -m -G audio,video,network,wheel,storage,lp,rfkill shyciii
echo "Shyciii jelszava:"
arch-chroot /mnt passwd shyciii

# Sudoers szerkesztése
#arch-chroot /mnt pacman -S --noconfirm vim
#arch-chroot /mnt visudo
#arch-chroot /mnt pacman -Rsn --noconfirm vim
arch-chroot /mnt echo 'shyciii ALL=(ALL) ALL' >> /etc/sudoers

# Leklónozott telepítési scriptek másolása a home könyvtárba
cd ..
cp -r archlinux/ /mnt/home/shyciii/

#reboot

###########################################################################
#Felhasználóval kell belépni, és mehet az Install2.sh script.
###########################################################################
