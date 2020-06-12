#!/bin/bash

bootctl --path=/boot install
echo -e "default  Arch\ntimeout 1" > /boot/loader/loader.conf
echo -e "Title Arch Linux\nlinux /vmlinuz-linux\ninitrd /intel-ucode.img\ninitrd /initramfs-linux.img\noptions root=PARTUUID=$(blkid | grep sda2 | sed 's/\(.*\)PARTUUID="\(.*\)"$/\2/') rw quit i915.enable_guc=2 loglevel=3" > /boot/loader/entries/Arch.conf
echo -e "127.0.0.1  localhost\n::1  localhost\n127.0.0.1  archlinux" > /etc/hosts
echo archlinux > /etc/hostname
echo KEYMAP=hu > /etc/vconsole.conf
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
#nvim /etc/locale.gen
locale-gen
rm /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Budapest /etc/localtime
hwclock --systohc --utc
timedatectl set-ntp true
# Network
pacman -S --noconfirm networkmanager network-manager-applet
systemctl enable NetworkManager.service
mkinitcpio -p linux
echo "Root jelszava:"
passwd root
# Esetleg innen jöhet a kilépés reboot és rootként belépés
echo "###########################################################################"
echo "Alábbi parancsokat kell kiadni, mielőtt az install3.sh scriptet lefuttatod:"
echo "exit, reboot"
echo "Ezután root felhasználóval lépj be, és mehet az Install3.sh script."
echo "###########################################################################"
