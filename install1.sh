#!/bin/bash

loadkeys hu
timdatectl set-ntp true
fdisk /dev/sda
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
#mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
pacstrap /mnt base linux linux-firmware nvim
mkdir /mnt/home
mkdir /mnt/home/Data
mount /dev/sda3 mnt/home/Data
chmod 777 mnt/home/Data
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
echo archlinux > /etc/hostname
echo KEYMAP=hu > /etc/vconsole.conf
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8
locale-gen
rm /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Budapest /etc/localtime
hwclock --systohc --utc
mkinitcpio -p linux
passwd root
useradd -m -g users -G audio,video,network,wheel,storage -s /bin/bash shyciii
passwd shyciii
pacman -S networkmanager
systemctl enable NetworkManager.service
exit
umount /dev/sda1
reboot
