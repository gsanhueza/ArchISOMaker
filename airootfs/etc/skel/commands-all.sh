# Copy mirror file and pacman configuration
echo "*** Installing packages from remote repos... ***"
cp /root/pacman_config_when_installed/pacman.conf /etc/pacman.conf -v
cp /root/pacman_config_when_installed/mirrorlist /etc/pacman.d/mirrorlist -v

# Create obligatory directories
newroot=/mnt
echo "Creating install root at ${newroot}"
mkdir -m 0755 -p "$newroot"/var/{cache/pacman/pkg,lib/pacman,log} "$newroot"/{dev,run,etc}
mkdir -m 1777 -p "$newroot"/tmp
mkdir -m 0555 -p "$newroot"/{sys,proc}

# Pull packages from the Internet
pacman -Syw --root /mnt --cachedir /mnt/var/cache/pacman/pkg --noconfirm base base-devel yaourt vim grml-zsh-config gstreamer smplayer nvidia bumblebee refind-efi grub os-prober xorg xorg-xinit xorg-drivers cantarell-fonts gnome gnome-tweak-tool plasma kdebase kde-l10n-es virtualbox-guest-modules-arch virtualbox-guest-utils intel-ucode lynx alsa-utils

# Copy packages to /media
echo ""
echo "*** Creating DB for all packages in /media ***"
mkdir /media
mount.vboxsf pkg /media
cp /mnt/var/cache/pacman/pkg /media -r
echo "*** Syncing... ***"
sync

# Create DB for packages in /media
echo "*** Creating new local DB... ***"
repo-add /media/pkg/custom.db.tar.gz /media/pkg/*.xz
sync

echo ""
echo "*** Local repo is ready! ***"

