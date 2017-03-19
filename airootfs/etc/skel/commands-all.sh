cp /root/pacman_config_when_installed/pacman.conf /etc/pacman.conf -v
cp /root/pacman_config_when_installed/mirrorlist /etc/pacman.d/mirrorlist -v
pacstrap /mnt base base-devel yaourt vim grml-zsh-config gstreamer smplayer mplayer nvidia bumblebee refind-efi grub os-prober xorg xorg-xinit xorg-drivers cantarell gnome gnome-tweak-tool plasma kdebase kde-l10n-es virtualbox-guest-modules-arch virtualbox-guest-utils intel-ucode i3 dmenu feh lxdm-gtk3 lynx compton network-manager-applet
