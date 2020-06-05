#!/bin/bash

echo "Shyciii user létrehozása"
useradd -m -g users -G audio,video,network,wheel,storage -s /bin/bash shyciii
echo "Shyciii jelszava:"
passwd shyciii
pacman -S xorg-server
chown shyciii:users /mnt/home/Data
fallocate -l 4096M /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
EDITOR=nvim visudo
localectl set-keymap hu hu
