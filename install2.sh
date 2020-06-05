#!/bin/bash

pacman -S xorg-server xorg-apps xorg-xinit
fallocate -l 4096M /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
EDITOR=nvim visudo
localectl set-keymap hu hu
