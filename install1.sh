#!/bin/bash

loadkeys hu
timedatectl set-ntp true
fdisk /dev/sda
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
pacstrap /mnt base linux linux-firmware neovim intel-ucode
mkdir /mnt/home/Data
mount /dev/sda3 /mnt/home/Data
chmod 777 /mnt/home/Data
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
bootctl --path=/boot install
nvim /boot/loader/loader.conf
echo -e "Title Arch Linux\nlinux /vmlinuz-linux\ninitrd /intel-ucode.img\ninitrd /initramfs-linux.img\noptions root=PARTUUID=$(blkid | grep sda2 | sed 's/\(.*\)PARTUUID="\(.*\)"$/\2/') rw quit i915.enable_guc=2 loglevel=3" > /boot/loader/entries/arch.conf
echo -e "127.0.0.1  localhost\n::1  localhost\n127.0.0.1  archlinux" > /etc/hosts
echo archlinux > /etc/hostname
echo KEYMAP=hu > /etc/vconsole.conf
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8
locale-gen
rm /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Budapest /etc/localtime
hwclock --systohc --utc
mkinitcpio -p linux
echo "Root jelszava:"
passwd root
pacman -S networkmanager
systemctl enable NetworkManager.service
exit
