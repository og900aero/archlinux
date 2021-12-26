sudo sed -i 's/main/main contrib non-free/' /etc/apt/sources.list
sudo sed -i 's/bullseye/testing/' /etc/apt/sources.list
sudo apt update
sudo apt dist-upgrade -y
sudo apt install wget curl xserver-xorg-video-intel xinit xserver-xorg-video-dummy xserver-xorg-input-all xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable fonts-font-asesome pulseaudio pavucontrol micro neofetch bspwm polybar rofi vifm xterm git imv trash-cli xclip transmission-gtk -y
sudo apt install exa dunst unzip unrar-free zip libreoffice htop mediainfo ffmpeg fzf subversion archivemount xsel xbacklight -y
bash -c "echo "exec bspwm' > /home/shyciii/.xinitrc"
mkdir -p /home/shyciii/.config/bspwm
mkdir -p /home/shyciii/.config/sxhkd
mkdir -p /home/shyciii/.config/rofi
mkdir -p /home/shyciii/.config/polybar
cp /home/shyciii/.bashrc /home/shyciii/.bashrc.bak
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.dev -y
rm ./google-chrome-stable_current_amd64.dev
sudo apt autoremove vim nano lemonbar -y
