source $PWD/env.sh

echo "+++ Linking zoneinfo... +++"
ln -s /usr/share/zoneinfo/America/Santiago /etc/localtime -f

echo "+++ Setting time... +++"
hwclock --systohc --utc

echo "+++ Enabling language and keymap... +++"
sed -i "s/#\(${LANGUAGE}\.UTF-8\)/\1/" /etc/locale.gen
echo "LANG=${LANGUAGE}es_CL.UTF-8" > /etc/locale.conf
echo "KEYMAP=la-latin1" > /etc/vconsole.conf
locale-gen

echo ""
echo "+++ Creating hostname '${HOSTNAME}'... +++"
echo $HOSTNAME > /etc/hostname

echo "+++ Enabling networking... +++"
systemctl enable NetworkManager.service

echo "+++ Enabling display manager... +++"
if [ $DESKTOP_ENV == "KDE" ]
then
	systemctl enable sddm.service
elif [ $DESKTOP_ENV == "GNOME" ]
then
	systemctl enable gdm.service
fi

echo ""
echo "+++ Creating linux image... +++"
mkinitcpio -p linux

echo ""
echo "+++ Setting root account... +++"
chsh -s /bin/zsh
passwd

echo ""
echo "+++ Creating '${USERNAME}' account... +++"
useradd -m -G wheel -s /bin/zsh $USERNAME 
passwd $USERNAME 

echo ""
echo "+++ Enabling sudo for '${USERNAME}'... +++"
sed -i 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\ALL\)/\1/' /etc/sudoers

echo ""
echo "+++ Installing ${BOOTLOADER} bootloader... +++"

if [ $BOOTLOADER == "grub" ]
then
	grub-install /dev/sda --force
	grub-mkconfig -o /boot/grub/grub.cfg
elif [ $BOOTLOADER == "refind" ]
then
	refind-install
	REFIND_UUID=$(cat /etc/fstab | grep UUID | grep "/ " | cut --fields=1)
	echo "\"Boot with standard options\"        \"rw root=${REFIND_UUID} initrd=/intel-ucode.img initrd=/initramfs-linux.img rcutree.rcu_idle_gp_delay=1 acpi_osi= acpi_backlight=native splash\"" > /boot/refind_linux.conf
fi

echo ""
echo "+++++++++++++++++++++++++++++++++++++++++++++++"
echo "+++                                         +++"
echo "+++  Finished! Will reboot in 3 seconds...  +++"
echo "+++                                         +++"
echo "+++++++++++++++++++++++++++++++++++++++++++++++"
exit

