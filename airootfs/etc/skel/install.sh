#!/bin/bash

SCRIPTFILE=${0##*/}
PKGFILE="packages.sh"
ENVFILE="env.sh"
CONFFILE="config.sh"

source $ENVFILE
source $PKGFILE

select_desktop_environment()
{
    # KDE vs GNOME vs i3 vs X11
    echo "*** Selecting ${DESKTOP_ENV}... ***"

    if [[ $DESKTOP_ENV == "KDE" ]]
    then
        export PACKAGES="$PACKAGES $KDE"
    elif [[ $DESKTOP_ENV == "GNOME" ]]
    then
        export PACKAGES="$PACKAGES $GNOME"
    elif [[ $DESKTOP_ENV == "i3" ]]
    then
        export PACKAGES="$PACKAGES $I3"
    elif [[ $DESKTOP_ENV == "X11" ]]
    then
        export PACKAGES="$PACKAGES $X11"
    fi
}

select_bootloader()
{
    # rEFInd vs GRUB
    echo "*** Selecting ${BOOTLOADER}... ***"

    if [[ $BOOTLOADER == "refind" ]]
    then
        export PACKAGES="$PACKAGES $REFIND"
    elif [[ $BOOTLOADER == "grub" ]]
    then
        export PACKAGES="$PACKAGES $GRUB"
    fi
}

select_video_drivers()
{
    # nVidia vs AMD vs VBox vs Intel
    echo "*** Selecting ${XORG_DRIVERS} drivers... ***"

    if [[ $XORG_DRIVERS == "nvidia" ]]
    then
        export PACKAGES="$PACKAGES $NVIDIA"
    elif [[ $XORG_DRIVERS == "amd" ]]
    then
        export PACKAGES="$PACKAGES $AMD"
    elif [[ $XORG_DRIVERS == "vbox" ]]
    then
        export PACKAGES="$PACKAGES $VBOX"
    elif [[ $XORG_DRIVERS == "intel" ]]
    then
        export PACKAGES="$PACKAGES $INTEL"
    fi
}

install_packages()
{
    # Installing here
    pacstrap /mnt $PACKAGES --cachedir=/root/pkg --needed
}

generate_fstab()
{
    genfstab -p -U /mnt > /mnt/etc/fstab
}

copy_mirrorlist()
{
    cp mirrorlist /mnt/etc/pacman.d/mirrorlist -v
}

copy_scripts()
{
    cp $ENVFILE /mnt/root -v
    cp $CONFFILE /mnt/root -v
    cp yay_install.sh /mnt/root -v
}

configure_system()
{
    echo ""
    echo "*** Now configuring your system with $DESKTOP_ENV, $BOOTLOADER and $XORG_DRIVERS... ***"
    arch-chroot /mnt /bin/zsh -c "cd && ./$CONFFILE && rm $CONFFILE $ENVFILE -f"
}

reboot_system()
{
    umount -R /mnt
    echo ""

    for i in 0 1 2
    do
        echo "Rebooting in $(expr 3 - $i) seconds..."
        sleep 1
    done

    echo "Rebooting now..."
    sleep 1
    sync
    reboot
}

prompt_username()
{
    printf "Write your name (default=$USERNAME): "
    read ans
    case $ans in
        '')
            return
        ;;
        *)
            export USERNAME=$ans
        ;;
    esac
}

prompt_hostname()
{
    printf "Write your hostname (default=${HOSTNAME}): "
    read ans
    case $ans in
        '')
            return
        ;;
        *)
            export HOSTNAME=$ans
        ;;
    esac
}

prompt_language()
{
    printf "Write your chosen language (default=$LANGUAGE): "
    read ans
    case $ans in
        '')
            return
        ;;
        *)
            export LANGUAGE=$ans
        ;;
    esac
}

prompt_keymap()
{
    # Keymap
    printf "Write your chosen keymap (default=$KEYMAP): "
    read ans
    case $ans in
        '')
            return
        ;;
        *)
            export KEYMAP=$ans
        ;;
    esac
}

prompt_zoneinfo()
{
    printf "Write your chosen zoneinfo (default=$ZONEINFO): "
    read ans
    case $ans in
        '')
            return
        ;;
        *)
            export ZONEINFO=$ans
        ;;
    esac
}

prompt_desktop_environment()
{
    # Desktop environment
    echo "Choose your Desktop Environment (default=$DESKTOP_ENV)"
    printf "(1) KDE    (2) GNOME    (3) i3    (4) X11: "
    read ans
    case $ans in
        '')
            return
        ;;
        '1')
            export DESKTOP_ENV="KDE"
        ;;
        '2')
            export DESKTOP_ENV="GNOME"
        ;;
        '3')
            export DESKTOP_ENV="i3"
        ;;
        '4')
            export DESKTOP_ENV="X11"
        ;;
        *)
            echo "Wrong choice, halting now!"
            exit 1
        ;;
    esac
}

prompt_bootloader()
{
    echo "Choose your Bootloader (default=$BOOTLOADER)"
    printf "(1) rEFInd    (2) GRUB: "
    read ans
    case $ans in
        '')
            return
        ;;
        '1')
            export BOOTLOADER="refind"
        ;;
        '2')
            export BOOTLOADER="grub"
        ;;
        *)
            echo "Wrong choice, halting now!"
            exit 1
        ;;
    esac
}

prompt_video_drivers()
{
    echo "Choose your Graphic Drivers (default=$XORG_DRIVERS)"
    printf "(1) nVidia    (2) AMD    (3) VBox    (4) Intel: "
    read ans
    case $ans in
        '')
            return
        ;;
        '1')
            export XORG_DRIVERS="nvidia"
        ;;
        '2')
            export XORG_DRIVERS="amd"
        ;;
        '3')
            export XORG_DRIVERS="vbox"
        ;;
        '4')
            export XORG_DRIVERS="intel"
        ;;
        *)
            echo "Wrong choice, halting now!"
            exit 1
        ;;
    esac
}

export_environment()
{
    # First 'echo' uses a single ">" because we want to re-write the file
    echo "USERNAME=$USERNAME" > $ENVFILE
    echo "HOSTNAME=$HOSTNAME" >> $ENVFILE
    echo "LANGUAGE=$LANGUAGE" >> $ENVFILE
    echo "KEYMAP=$KEYMAP" >> $ENVFILE
    echo "ZONEINFO=$ZONEINFO" >> $ENVFILE
    echo "DESKTOP_ENV=$DESKTOP_ENV" >> $ENVFILE
    echo "BOOTLOADER=$BOOTLOADER" >> $ENVFILE
    echo "XORG_DRIVERS=$XORG_DRIVERS" >> $ENVFILE
}

customize_env() {
    echo "I'll now ask for data needed to install your system."
    echo "If you leave it blank, it will just use the defaults set in '$ENVFILE'."
    echo ""

    prompt_username
    prompt_hostname
    prompt_language
    prompt_keymap
    prompt_zoneinfo
    prompt_desktop_environment
    prompt_bootloader
    prompt_video_drivers

    export_environment
}

check_mounted_drive() {
    MOUNTPOINT="/mnt"
    B=$(tput bold)
    N=$(tput sgr0)

    if [[ $(findmnt -M "$MOUNTPOINT") ]]; then
        echo "Drive mounted in $MOUNTPOINT."
    else
        echo "Drive is ${B}NOT MOUNTED!${N}"
        echo "Mount your drive in '$MOUNTPOINT' and re-run '$SCRIPTFILE' to install your system."
        exit 1
    fi
}

prompt_customize()
{
    printf "Do you want to use defaults? (See $ENVFILE) (Y/n): "
    read defaults
    case $defaults in
        'n'|'N')
            customize_env
        ;;
    esac
}

prompt_failure()
{
    echo ""
    echo "----------------------------------------------------"
    echo "---                                              ---"
    echo "---  Something wrong happened, will not reboot.  ---"
    echo "---                                              ---"
    echo "----------------------------------------------------"
}

install_system()
{
    select_desktop_environment
    select_bootloader
    select_video_drivers

    install_packages
    generate_fstab

    copy_mirrorlist
    copy_scripts

    configure_system
}

verify_installation()
{
    [[ ! -f /mnt/root/$CONFFILE && ! -f /mnt/root/$ENVFILE ]]
}

# Execute main
check_mounted_drive
prompt_customize
install_system
verify_installation

if [[ $? == 0 ]]; then
    reboot_system
else
    prompt_failure
fi
