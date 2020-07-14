#!/bin/bash

loadkeys hu
pacman -Sy
pacman -S --noconfirm reflector
reflector --verbose --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
timedatectl set-ntp true
fdisk /dev/sda
mkfs.fat -F32 /dev/sda1
mkfs.ext4 -F /dev/sda2
mount /dev/sda2 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
pacstrap /mnt base base-devel linux linux-firmware neovim intel-ucode
mkdir -p /mnt/home/Data
mount /dev/sda3 /mnt/home/Data
chmod 777 /mnt/home/Data
genfstab -U /mnt >> /mnt/etc/fstab
sed -i 's/rw,relatime/defaults,discard,noatime/g' /mnt/etc/fstab
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
echo -e "127.0.0.1  localhost\n::1  localhost\n127.0.0.1  archlinux" > /mnt/etc/hosts
echo archlinux > /mnt/etc/hostname
echo KEYMAP=hu > /mnt/etc/vconsole.conf
echo LANG=en_US.UTF-8 > /mnt/etc/locale.conf
arch-chroot /mnt export LANG=en_US.UTF-8
echo "en_US.UTF-8 UTF-8" >> /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
arch-chroot /mnt rm /etc/localtime
arch-chroot /mnt ln -s /usr/share/zoneinfo/Europe/Budapest /mnt/etc/localtime
arch-chroot /mnt hwclock --systohc --utc
# Network
arch-chroot /mnt pacman -S --noconfirm networkmanager network-manager-applet networkmanager-openvpn
arch-chroot /mnt systemctl enable NetworkManager.service
arch-chroot /mnt mkinitcpio -p linux
echo "Root jelszava:"
arch-chroot /mnt passwd root
# User
echo "Shyciii user létrehozása"
arch-chroot /mnt useradd -m -g users -G audio,video,network,wheel,storage,rfkill shyciii
echo "Shyciii jelszava:"
arch-chroot /mnt passwd shyciii
# Swap file
arch-chroot /mnt dd if=/dev/zero of=/swapfile bs=1M count=2048 status=progress
arch-chroot /mnt chmod 600 /swapfile
arch-chroot /mnt mkswap /swapfile
arch-chroot /mnt swapon /swapfile
echo "/swapfile   none  swap  defaults,discard  0	0" >> /mnt/etc/fstab
# Xorg
arch-chroot /mnt pacman -S --noconfirm xorg-server xorg-xinit xorg-fonts-encodings xorg-mkfontscale xterm mesa xf86-video-intel xf86-video-nouveau
# Install fonts, home dirs etc
arch-chroot /mnt pacman -S --noconfirm xdg-user-dirs bind-tools wget traceroute man-db man-pages intel-media-driver pacman-contrib bash-completion android-tools gvfs udiskie awesome-terminal-fonts ttf-hack ttf-ubuntu-font-family ttf-roboto ttf-dejavu git ntfs-3g gnome-keyring reflector polkit-gnome
# Install Sound
arch-chroot /mnt pacman -S --noconfirm pulseaudio pavucontrol pulseaudio-bluetooth
cd ..
cp -r archlinux/ /mnt/home/
# Edit sudoers
arch-chroot /mnt pacman -S --noconfirm vim
arch-chroot /mnt visudo
arch-chroot /mnt pacman -Rsn --noconfirm vim
reboot
echo "###########################################################################"
echo "shyciii felhasználóval lépj be, és mehet az Install2.sh script."
echo "###########################################################################"
