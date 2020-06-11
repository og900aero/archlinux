#!/bin/bash

bootctl --path=/boot install
echo -e "default arch\ntimeout 1\neditor 1" > /boot/loader/loader.conf
#nvim /boot/loader/loader.conf
echo -e "Title Arch Linux\nlinux /vmlinuz-linux\ninitrd /intel-ucode.img\ninitrd /initramfs-linux.img\noptions root=PARTUUID=$(blkid | grep sda2 | sed 's/\(.*\)PARTUUID="\(.*\)"$/\2/') rw quit i915.enable_guc=2 loglevel=3" > /boot/loader/entries/arch.conf
echo -e "127.0.0.1  localhost\n::1  localhost\n127.0.0.1  archlinux" > /etc/hosts
echo archlinux > /etc/hostname
echo KEYMAP=hu > /etc/vconsole.conf
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8
nvim /etc/locale.gen
locale-gen
rm /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Budapest /etc/localtime
hwclock --systohc --utc
mkinitcpio -p linux
echo "Root jelszava:"
passwd root
pacman -S --noconfirm networkmanager network-manager-applet
systemctl enable NetworkManager.service
echo "Shyciii user létrehozása"
useradd -m -g users -G audio,video,network,wheel,storage,rfkill shyciii
echo "Shyciii jelszava:"
passwd shyciii
EDITOR=nvim visudo
# Swap file
sudo fallocate -l 4096M /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo "###########################################################################"
echo "Alábbi parancsokat kell kiadni, mielőtt az Install3.sh scriptet lefuttatod:"
echo "exit, umount -R /dev/sda, reboot"
echo "Ezután root felhasználóval lépj be, és mehet az Install3.sh script.
echo "###########################################################################"
