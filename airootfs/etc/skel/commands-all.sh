echo "*** Installing packages from remote repos... ***"
cp /root/pacman_config_when_installed/pacman.conf /etc/pacman.conf -v
cp /root/pacman_config_when_installed/mirrorlist /etc/pacman.d/mirrorlist -v
pacstrap /mnt base base-devel yaourt vim grml-zsh-config gstreamer smplayer nvidia bumblebee refind-efi grub os-prober xorg xorg-xinit xorg-drivers cantarell-fonts gnome gnome-tweak-tool plasma kdebase kde-l10n-es virtualbox-guest-modules-arch virtualbox-guest-utils intel-ucode i3 dmenu feh lxdm-gtk3 lynx compton xterm pcmanfm-gtk3 alsa-utils

echo ""
echo "*** Creating DB for all packages in /media ***"
mkdir /media
mount.vboxsf pkg /media
cp /mnt/var/cache/pacman/pkg /media -r
echo "*** Syncing... ***"
sync
echo "*** Creating new local DB... ***"
repo-add /media/pkg/custom.db.tar.gz /media/pkg/*.xz
sync

echo ""
echo "*** Local repo is ready! ***"

