# Copy mirror file and pacman configuration
echo "*** Installing packages from remote repos... ***"
cp /root/pacman_config_when_installed/pacman.conf /etc/pacman.conf -v
cp /root/pacman_config_when_installed/mirrorlist /etc/pacman.d/mirrorlist -v

# Create obligatory directories
newroot=/mnt
pkgdb=/media

echo "Creating install root at ${newroot}"
mkdir -m 0755 -p "$newroot"/var/{cache/pacman/pkg,lib/pacman,log} "$newroot"/{dev,run,etc}
mkdir -m 1777 -p "$newroot"/tmp
mkdir -m 0555 -p "$newroot"/{sys,proc}

# Pull packages from the Internet
pacman -Syw --root "$newroot" --cachedir "$newroot"/var/cache/pacman/pkg --noconfirm base base-devel yaourt vim grml-zsh-config gstreamer smplayer nvidia bumblebee refind-efi grub os-prober xorg xorg-xinit xorg-drivers cantarell-fonts gnome gnome-tweak-tool plasma kdebase kde-l10n-es virtualbox-guest-modules-arch virtualbox-guest-utils intel-ucode lynx alsa-utils

# Copy packages to ${pkgdb} 
echo ""
echo "*** Creating DB for all packages in ${pkgdb} ***"
mkdir -p "$pkgdb"
mount.vboxsf pkg "$pkgdb"
cp "$newroot"/var/cache/pacman/pkg "$pkgdb" -r
echo "*** Syncing... ***"
sync

# Create DB for packages in ${pkgdb}
echo "*** Creating new local DB... ***"
repo-add "$pkgdb"/pkg/custom.db.tar.gz "$pkgdb"/pkg/*.xz
sync

echo ""
echo "*** Local repo is ready! ***"

