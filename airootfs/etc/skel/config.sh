source /root/env.sh

set_zoneinfo()
{
    echo "+++ Linking zoneinfo... +++"
    ln -s /usr/share/zoneinfo/$1 /etc/localtime -f
}

enable_utc()
{
    echo "+++ Setting time... +++"
    hwclock --systohc --utc
}

set_language()
{
    echo "+++ Enabling language and keymap... +++"
    sed -i "s/#\($1\.UTF-8\)/\1/" /etc/locale.gen
    echo "LANG=$1.UTF-8" > /etc/locale.conf
    echo "KEYMAP=la-latin1" > /etc/vconsole.conf
    locale-gen
}

set_hostname()
{
    echo ""
    echo "+++ Creating hostname" $1 "... +++"
    echo $1 > /etc/hostname
}

enable_networking()
{
    echo "+++ Enabling networking... +++"
    systemctl enable NetworkManager.service
}

enable_desktop_manager()
{
    echo "+++ Enabling display manager... +++"
    if [ $DESKTOP_ENV == "KDE" ]
    then
    	systemctl enable sddm.service
    elif [ $DESKTOP_ENV == "GNOME" ]
    then
    	systemctl enable gdm.service
    elif [ $DESKTOP_ENV == "i3" ]
    then
    	systemctl enable sddm.service
    fi
}

make_linux_image()
{
    echo ""
    echo "+++ Creating linux image... +++"
    mkinitcpio -p linux
}

configure_root_account()
{
    echo ""
    echo "+++ Setting root account... +++"
    chsh -s /bin/zsh
    passwd

    while (( $? != 0 )); do
        echo ""
        echo "Try again!"
        passwd
    done
}

set_user_account()
{
    echo ""
    echo "+++ Creating" $1 "account... +++"
    useradd -m -G wheel -s /bin/zsh "$1"
    passwd "$1"

    while (( $? != 0 )); do
        echo ""
        echo "Try again!"
        passwd "$1"
    done

    echo ""
    echo "+++ Enabling sudo for" $1 "... +++"
    sed -i 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\ALL\)/\1/' /etc/sudoers
}

install_bootloader()
{
    echo ""
    echo "+++ Installing" $1 "bootloader... +++"

    if [ "$1" == "grub" ]
    then
	grub-install $(findmnt / -o SOURCE | tail -n 1 | awk -F'[0-9]' '{ print $1 }') --force
    	grub-mkconfig -o /boot/grub/grub.cfg
    elif [ "$1" == "refind" ]
    then
	# Bait refind-install into thinking that a refind install already exists,
	# so it will "upgrade" (install) in default location /boot/EFI/refind
	# This is done to avoid moving Microsoft's original bootloader.

	# Comment the following two lines if you have an HP computer
	# (suboptimal EFI implementation), or you don't mind moving
	# the original bootloader.
   	mkdir -p /boot/EFI/refind
	cp /usr/share/refind/refind.conf-sample /boot/EFI/refind/refind.conf

    	refind-install
    	REFIND_UUID=$(cat /etc/fstab | grep UUID | grep "/ " | cut --fields=1)
    	echo "\"Boot with standard options\"        \"rw root=${REFIND_UUID} initrd=/intel-ucode.img initrd=/initramfs-linux.img rcutree.rcu_idle_gp_delay=1 acpi_osi= acpi_backlight=native splash\"" > /boot/refind_linux.conf
    fi
}

set_zoneinfo "America/Santiago"
enable_utc
set_language $LANGUAGE
set_hostname $HOSTNAME
enable_networking
enable_desktop_manager
make_linux_image
configure_root_account
set_user_account $USERNAME
install_bootloader $BOOTLOADER

echo ""
echo "+++++++++++++++++++++++++++++++++++++++++++++++"
echo "+++                                         +++"
echo "+++  Finished! Will reboot in 3 seconds...  +++"
echo "+++                                         +++"
echo "+++++++++++++++++++++++++++++++++++++++++++++++"
exit

