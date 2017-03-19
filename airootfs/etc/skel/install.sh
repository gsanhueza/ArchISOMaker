source $PWD/env.sh

PACKAGES="base base-devel yaourt vim grml-zsh-config gstreamer smplayer mplayer xorg-server cantarell-fonts xorg-xinit xf86-input-libinput intel-ucode alsa-utils"

# KDE vs GNOME
echo "*** Installing ${DESKTOP_ENV}... ***"
if [ $DESKTOP_ENV == "KDE" ] 
then
	PACKAGES="$PACKAGES plasma kdebase kde-l10n-es" 
elif [ $DESKTOP_ENV == "GNOME" ] 
then
	PACKAGES="$PACKAGES gnome gnome-tweak-tool"
elif [ $DESKTOP_ENV == "i3" ] 
then
	PACKAGES="$PACKAGES i3 dmenu xterm feh lynx lxdm-gtk3 compton network-manager-applet networkmanager"
fi

# rEFInd vs GRUB
echo "*** Installing ${BOOTLOADER}... ***"
if [[ $BOOTLOADER == "refind" ]] 
then
	PACKAGES="$PACKAGES refind-efi"
elif [[ $BOOTLOADER == "grub" ]] 
then
	PACKAGES="$PACKAGES grub os-prober"
fi

# nVidia vs AMD vs VBox
echo "*** Installing Drivers... ***"
if [[ $XORG_DRIVERS == "vbox" ]] 
then
	PACKAGES="$PACKAGES virtualbox-guest-modules-arch virtualbox-guest-utils" 
elif [[ $XORG_DRIVERS == "nvidia" ]] 
then
	PACKAGES="$PACKAGES nvidia bumblebee" 
elif [[ $XORG_DRIVERS == "amd" ]] 
then
	PACKAGES="$PACKAGES xf86-video-ati" 
fi

# Installing here
pacstrap /mnt $PACKAGES --cachedir=/root/pkg --needed

genfstab -p -U /mnt > /mnt/etc/fstab
cp pacman_config_when_installed/pacman.conf /mnt/etc/pacman.conf -v
cp pacman_config_when_installed/mirrorlist /mnt/etc/pacman.d/mirrorlist -v

cp $PWD/env.sh /mnt/root -v
cp $PWD/config.sh /mnt/root -v

echo ""
echo "*** Now configuring your system with ${DESKTOP_ENV}, ${BOOTLOADER} and ${XORG_DRIVERS}... ***"
arch-chroot /mnt /bin/zsh -c "cd && ./config.sh && rm config.sh env.sh -f"
umount -R /mnt

echo ""
echo "*** Syncing drives ***"
sync

for i in 0 1 2 
do
	echo "Rebooting in $(expr 3 - $i) seconds..."
	sleep 1
done

echo "Rebooting now..."
sleep 1
reboot

