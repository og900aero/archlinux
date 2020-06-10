#!/bin/bash

loadkeys hu
pacman -Sy
pacman -S --noconfirm reflector
reflector --verbose --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
timedatectl set-ntp true
fdisk /dev/sda
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
pacstrap /mnt base base-devel linux linux-firmware linux-headers neovim intel-ucode
mkdir /mnt/home/Data
mount /dev/sda3 /mnt/home/Data
chmod 777 /mnt/home/Data
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
