#!/bin/bash

bootctl --path=/boot install
echo -e "default arch.conf\ntimeout 1" > /boot/loader/loader.conf
echo -e "Title Arch Linux\nlinux /vmlinuz-linux\ninitrd /intel-ucode.img\ninitrd /initramfs-linux.img\noptions root=PARTUUID=$(blkid | grep sda2 | sed 's/\(.*\)PARTUUID="\(.*\)"$/\2/') rw quit i915.enable_guc=2 loglevel=3" > /boot/loader/entries/arch.conf
echo -e "127.0.0.1  localhost\n::1  localhost\n127.0.0.1  archlinux" > /etc/hosts
echo archlinux > /etc/hostname
echo KEYMAP=hu > /etc/vconsole.conf
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
rm /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Budapest /etc/localtime
hwclock --systohc --utc
timedatectl set-ntp true
# Network
pacman -S --noconfirm networkmanager network-manager-applet networkmanager-openvpn
systemctl enable NetworkManager.service
mkinitcpio -p linux
echo "Root jelszava:"
passwd root
# User
echo "Shyciii user létrehozása"
useradd -m -g users -G audio,video,network,wheel,storage,rfkill shyciii
echo "Shyciii jelszava:"
passwd shyciii
EDITOR=nvim visudo
# Swap file
sudo dd if=/dev/zero of=/swapfile bs=1M count=2048 status=progress
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo echo "/swapfile   none  swap  defaults,discard  0	0" >> /etc/fstab
# Xorg
sudo pacman -S --noconfirm xorg-server xorg-xinit xorg-fonts-encodings xorg-mkfontscale xterm mesa xf86-video-intel
# Install fonts, home dirs etc
sudo pacman -S --noconfirm xdg-user-dirs git bind-tools wget traceroute man-db man-pages intel-media-driver pacman-contrib bash-completion android-tools gvfs udiskie awesome-terminal-fonts ttf-ubuntu-font-family ttf-roboto ttf-dejavu git ntfs-3g gnome-keyring reflector polkit-gnome
# Install Sound
sudo pacman -S --noconfirm pulseaudio pavucontrol pulseaudio-bluetooth
echo "###########################################################################"
echo "Alábbi parancsokat kell kiadni, mielőtt az install3.sh scriptet lefuttatod:"
echo "exit, reboot"
echo "Ezután shyciii felhasználóval lépj be, és mehet az Install3.sh script."
echo "###########################################################################"
