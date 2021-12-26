sudo sed -i 's/main/main contrib non-free/' /etc/apt/sources.list
sudo sed -i 's/bullseye/testing/' /etc/apt/sources.list
sudo apt update
sudo apt dist-upgrade
sudo apt install wget curl xserver-xorg xinit xserver-xorg-input-all fonts-font-asesome pulseaudio pavucontrol micro neofetch bspwm polybar rofi vifm rxvt-unicode git imv trash-cli xclip transmission-gtk
sudo apt install exa dunst unzip unrar-free zip libreoffice htop mediainfo ffmpeg fzf subversion archivemount xsel xbacklight
bash -c "echo "exec bspwm' > /home/shyciii/.xinitrc"
mkdir -p /home/shyciii/.config/bspwm
mkdir -p /home/shyciii/.config/sxhkd
mkdir -p /home/shyciii/.config/rofi
mkdir -p /home/shyciii/.config/polybar
cp /home/shyciii/.bashrc /home/shyciii/.bashrc.bak
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.dev
rm ./google-chrome-stable_current_amd64.dev
sudo apt autoremove vim nano
