#!/usr/bin/env bash

SCRIPTFILE=${0##*/}
PRINTERFILE="printer.sh"
ENVFILE="env.sh"

source /root/$PRINTERFILE
source /root/$ENVFILE

set_zoneinfo()
{
    print_message ">>> Linking zoneinfo <<<"
    ln -s /usr/share/zoneinfo/$ZONEINFO /etc/localtime -f
}

enable_utc()
{
    print_message ">>> Setting time <<<"
    hwclock --systohc --utc
}

set_language()
{
    print_message ">>> Enabling language and keymap <<<"

    sed -i "s/#\($LANGUAGE\.UTF-8\)/\1/" /etc/locale.gen
    echo "LANG=$LANGUAGE.UTF-8" > /etc/locale.conf
    echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf
    locale-gen
}

set_hostname()
{
    print_message ">>> Creating hostname $HOSTNAME <<<"
    echo $HOSTNAME > /etc/hostname
}

enable_networking()
{
    print_message ">>> Enabling networking <<<"

    if [[ $(pacman -Qsq networkmanager) ]]; then
        systemctl enable NetworkManager.service
    else
        systemctl enable systemd-networkd.service
        systemctl enable systemd-resolved.service
    fi
}

enable_desktop_manager()
{
    print_message ">>> Enabling display manager <<<"

    if [[ $DESKTOP_ENV == "KDE" ]]; then
        systemctl enable sddm.service
    elif [[ $DESKTOP_ENV == "GNOME" ]]; then
        systemctl enable gdm.service
    elif [[ $DESKTOP_ENV == "i3" ]]; then
        systemctl enable sddm.service
    fi
}

setup_root_account()
{
    print_message ">>> Setting root account <<<"
    chsh -s $USERSHELL

    # This is insecure AF, don't use this if your machine is being monitored
    echo "root:$PASSWORD" | chpasswd
}

setup_user_account()
{
    print_message ">>> Creating $USERNAME account <<<"
    useradd -m -G wheel -s $USERSHELL $USERNAME

    # This is insecure AF, don't use this if your machine is being monitored
    echo "$USERNAME:$PASSWORD" | chpasswd

    print_message ">>> Enabling sudo for $USERNAME <<<"
    sed -i 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\ALL\)/\1/' /etc/sudoers

    print_message ">>> Moving AUR Helper instalation script to user folder <<<"

    mv /root/yay_install.sh /home/$USERNAME/ -v
    chown $USERNAME:$USERNAME /home/$USERNAME/yay_install.sh -v
}

install_grub()
{
    grub-install $(findmnt / -o SOURCE | tail -n 1 | awk -F'[0-9]' '{ print $1 }') --force
    grub-mkconfig -o /boot/grub/grub.cfg
}

install_refind()
{
    # Bait refind-install into thinking that a refind install already exists,
    # so it will "upgrade" (install) in desired location /boot/EFI/refind
    # This is done to avoid moving Microsoft's original bootloader.

    # Comment the following two lines if you have an HP computer
    # (suboptimal EFI implementation), or you don't mind moving
    # the original bootloader.
    mkdir -p /boot/EFI/refind
    cp /usr/share/refind/refind.conf-sample /boot/EFI/refind/refind.conf

    refind-install
    REFIND_UUID=$(cat /etc/fstab | grep UUID | grep "/ " | cut --fields=1)
    echo "\"Boot using default options\"     \"root=${REFIND_UUID} rw add_efi_memmap initrd=intel-ucode.img initrd=amd-ucode.img initrd=initramfs-linux.img" > /boot/refind_linux.conf
    echo "\"Boot using fallback initramfs\"  \"root=${REFIND_UUID} rw add_efi_memmap initrd=intel-ucode.img initrd=amd-ucode.img initrd=initramfs-linux-fallback.img" >> /boot/refind_linux.conf
    echo "\"Boot to terminal\"               \"root=${REFIND_UUID} rw add_efi_memmap initrd=intel-ucode.img initrd=amd-ucode.img initrd=initramfs-linux.img systemd.unit=multi-user.target" >> /boot/refind_linux.conf
}

install_bootloader()
{
    print_message ">>> Installing $BOOTLOADER bootloader <<<"

    if [ "$BOOTLOADER" == "grub" ]; then
        install_grub
    elif [ "$BOOTLOADER" == "refind" ]; then
        install_refind
    fi
}

clean_up()
{
    print_success ">>> Ready! Cleaning up <<<"

    rm $ENVFILE -vf
    rm $PRINTERFILE -vf
    rm $SCRIPTFILE -vf
}

main()
{
    set_zoneinfo &&
    enable_utc &&
    set_language &&
    set_hostname &&
    enable_networking &&
    enable_desktop_manager &&
    setup_root_account &&
    setup_user_account &&
    install_bootloader &&
    clean_up
}

# Execute main
main

