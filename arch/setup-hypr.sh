#!/bin/sh

# Prerequisites
doas pacman -S stow rustup fzf go lf autoconf automake binutils bison debugedit fakeroot file findutils flex gawk gcc gettext grep groff gzip libtool m4 make patch pkgconf texinfo which unzip nodejs npm pnpm unrar p7zip --noconfirm

# Dotfiles
## Make directory where to store dotfiles
cd ~
mkdir -p Documents/coding

## Clone repo, stow it and source the env-vars
git clone https://gitlab.com/bentowali/dotfiles Documents/coding/dotfiles
cd Documents/coding/dotfiles
stow . -t ~
cd ~
source ~/.config/zsh/.zshenv

## Zap Zsh (plugin manager)
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1 --keep

# Paru (AUR Helper)
## Install rust
rustup default stable

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
doas pacman -S hyprland hyprcursor hypridle hyprlock hyprutils xdg-desktop-portal-hyprland wl-clipboard grim slurp udisks2 udiskie alacritty pipewire pipewire-{pulse,alsa,jack} waybar dunst rofi-wayland pulsemixer playerctl gammastep --noconfirm

## Applications
doas pacman -S steam zathura zathura-pdf-poppler mpv keepassxc obsidian gamemode fastfetch glow openssh ssh-tools lazygit meson ninja imagemagick --noconfirm

## Wine
doas pacman -S wine winetricks wine-nine wine-gecko wine-mono --noconfirm

## VM
doas pacman -S qemu-desktop virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat ebtables iptables libguestfs --noconfirm
### Configure
doas systemctl enable libvirtd.service --now
doas sed -i "/unix_sock_group/"'s/^#//' /etc/libvirt/libvirtd.conf
doas sed -i "/unix_sock_rw_perms/"'s/^#//' /etc/libvirt/libvirtd.conf
doas usermod -aG audio,kvm,libvirt $(whoami)
doas systemctl restart libvirtd.service
doas sysctl -w vm.max_map_count=2147483642

## AUR
paru -S sleepy-launcher-bin selectdefaultapplication-fork-git xdg-ninja spotify raindrop librewolf-bin vesktop-bin rofi-emoji-git --noconfirm