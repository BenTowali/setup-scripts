#!/bin/sh

# Prerequisites
doas pacman -S zoxide stow rustup fzf go lf autoconf automake binutils bison debugedit fakeroot file findutils flex gawk gcc gettext grep groff gzip libtool m4 make patch pkgconf texinfo which unzip nodejs npm pnpm unrar p7zip --noconfirm

# Dotfiles
## Make directory where to store dotfiles
cd ~
mkdir -p Programmation/projects

## Clone repo, stow it and source the env-vars
git clone https://github.com/bentowali/dotfiles-laptop Programmation/projects/dotfiles
cd Programmation/projects/dotfiles
stow . -t /home/$(whoami)
cd ~
source ~/.config/zsh/.zshenv

## Zap Zsh (plugin manager)
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1 --keep

# Paru (AUR Helper)
## Install rust
rustup default stable
rustup component add rust-analyzer

## Symlink doas to sudo because of makepkg
doas ln -s $(which doas) /usr/bin/sudo

## Clone repo and install it
git clone https://aur.archlinux.org/paru.git
cd paru && makepkg -si

## Install it with pacman -U cause makepkg gives a warning
doas pacman -U paru-*.pkg.tar.zst --noconfirm
cd .. && rm -rf paru

# Install main stuff
## Fonts
doas pacman -S noto-fonts noto-fonts-extra noto-fonts-cjk noto-fonts-emoji ttf-jetbrains-mono ttf-jetbrains-mono-nerd --noconfirm

## Hyprland
doas pacman -S hyprpaper hyprland hyprcursor hypridle hyprlock hyprutils xdg-desktop-portal-hyprland wl-clipboard grim slurp udisks2 udiskie alacritty pipewire pipewire-{pulse,alsa,jack} waybar dunst rofi-wayland pulsemixer playerctl gammastep papirus-icon-theme --noconfirm

## Applications
doas pacman -S retroarch retroarch-assets-{glui,ozone,xmb} syncthing nsxiv nwg-look qt6ct steam zathura zathura-pdf-poppler mpv keepassxc obsidian fastfetch lazygit --noconfirm

## Tools
doas pacman -S mame-tools thunar thunar-volman gvfs bluez bluez-utils bluetuith brightnessctl btop tldr polkit polkit-kde-agent trash-cli clang glow gamemode meson ninja openssh ssh-tools imagemagick --noconfirm

## Wine
doas pacman -S wine winetricks wine-nine wine-gecko wine-mono --noconfirm

# System config
doas sysctl -w vm.max_map_count=2147483642
## Bluetooth
doas systemctl enable --now bluetooth.service
doas sed -i '/AutoEnable=true/s/^#//' /etc/bluetooth/main.conf

## AUR
paru -S selectdefaultapplication-fork-git ani-cli xdg-ninja spotify raindrop librewolf-bin vesktop-bin rofi-emoji-git catppuccin-gtk-theme-mocha spicetify-cli --noconfirm
