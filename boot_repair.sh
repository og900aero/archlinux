#!/bin/bash

loadkeys hu
mkfs.fat -F32 /dev/sda1
mount /dev/sda1 /mnt/boot

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
