#!/bin/bash

# Magyar billentyűzet
loadkeys hu

# A 10 leggyorsabb mirror szerver beállítása
pacman -Sy --noconfirm reflector
reflector --verbose --latest 10 --sort rate --save /etc/pacman.d/mirrorlist

read -n 1

# Idő szinkronizálás engedélyezése távoli idő kiszolgálóval
timedatectl set-ntp true

read -n 1

# Saját partíciók kezelése, beállítása
#cfdisk
#mkfs.fat -F32 /dev/sda1
#mkfs.ext4 /dev/sda2

# Root felcsatolása
mount /dev/sda2 /mnt

read -n 1

# Boot szerkezet létrehozása, felcsatolása
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

read -n 1

# Alap rendszer telepítése
pacstrap /mnt base base-devel linux linux-firmware vim intel-ucode

# Saját Data könyvtár létrehozása, és felmountolása
mkdir -p /mnt/home/Data
mount /dev/sda3 /mnt/home/Data
chmod 777 /mnt/home/Data

read -n 1

# Fstab létrehozása, SSD.nek megfelelő értékekre cserélés
genfstab -U /mnt >> /mnt/etc/fstab
sed -i 's/rw,relatime/defaults,discard,noatime/g' /mnt/etc/fstab

read -n 1

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
options  root=PARTUUID=$(blkid | grep sda2 | sed 's/\(.*\)PARTUUID="\(.*\)"$/\2/') rw quit i915.enable_guc=2 loglevel=3
EOF

read -n 1

# Magyar időzóna beállítása
ln -sf /mnt/usr/share/zoneinfo/Europe/Budapest /mnt/etc/localtime

read -n 1

arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Budapest /etc/localtime

read -n 1

# Hardver óra beállítása
arch-chroot /mnt hwclock --systohc

read -n 1

# Lokális nyelvezet beállítása angolra, de magyar időformátumra
echo "en_US.UTF-8 UTF-8" >> /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf

read -n 1

# Parancssori billentyűzet beállítása
echo KEYMAP=hu > /mnt/etc/vconsole.conf

read -n 1

# Host beállítása
echo -e "127.0.0.1  localhost\n::1  localhost\n127.0.0.1  archlinux" > /mnt/etc/hosts
echo "archlinux" > /mnt/etc/hostname
cat <<EOF > /etc/hosts
127.0.0.1	localhost
::1		localhost
127.0.1.1	archlinux.localdomain	archlinux
EOF

read -n 1

# Naplózás beállítása
echo "MaxRetentionSec=15day" >> /mnt/etc/systemd/journald.conf

read -n 1

# Hálózati komponensek telepítése
arch-chroot /mnt pacman -S --noconfirm networkmanager network-manager-applet networkmanager-openvpn

sleep 5

arch-chroot /mnt systemctl enable NetworkManager.service

read -n 1

# mkinitcpio manuális futtatás (initial ramdisk)
arch-chroot /mnt mkinitcpio -p linux

read -n 1

# Root jelszó beállítása
echo "Root jelszava:"
arch-chroot /mnt passwd root

read -n 1

# Felhasználó létrehozása, csoportokhoz hozzáadása, jelszó létrehozása
arch-chroot /mnt useradd -m -g users -G audio,video,network,wheel,storage,rfkill shyciii
echo "Shyciii jelszava:"
arch-chroot /mnt passwd shyciii

read -n 1

# Swap file létrehozása
arch-chroot /mnt dd if=/dev/zero of=/swapfile bs=1M count=2048 status=progress
arch-chroot /mnt chmod 600 /swapfile
arch-chroot /mnt mkswap /swapfile
arch-chroot /mnt swapon /swapfile
echo "/swapfile   none  swap  defaults,discard  0	0" >> /mnt/etc/fstab

read -n 1

# Install Xorg, videó driverek
arch-chroot /mnt pacman -S --noconfirm xorg-server xorg-xinit xorg-fonts-encodings xorg-mkfontscale xterm mesa xf86-video-intel xf86-video-nouveau

read -n 1

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

read -n 1

# Install fonts, home dirs etc
arch-chroot /mnt pacman -S --noconfirm xdg-user-dirs bind wget traceroute man-db man-pages intel-media-driver pacman-contrib bash-completion android-tools gvfs gfvs-mtp udiskie awesome-terminal-fonts ttf-hack ttf-ubuntu-font-family ttf-roboto ttf-dejavu git ntfs-3g gnome-keyring reflector polkit-gnome

read -n 1

# Install Sound
arch-chroot /mnt pacman -S --noconfirm pulseaudio pavucontrol pulseaudio-bluetooth
cd ..

read -n 1

# Leklónozott telepítési scriptek másolása a home könyvtárba
cp -r archlinux/ /mnt/home/shyciii/

read -n 1

# Sudoers szerkesztése
arch-chroot /mnt visudo
arch-chroot /mnt pacman -Rsn --noconfirm vim

read -n 1

#reboot

###########################################################################
#Felhasználóval kell belépni, és mehet az Install2.sh script.
###########################################################################
