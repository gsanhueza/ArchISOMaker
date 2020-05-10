#!/bin/bash

INTERACTIVE=1
AUTOREBOOT=1

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
    printf "Enter your name (default=$USERNAME): "
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

prompt_password()
{
    printf "Enter your password (default=$PASSWORD): "
    read -s ans
    echo
    case $ans in
        '')
            return
        ;;
        *)
            export PASSWORD=$ans
        ;;
    esac
}

prompt_hostname()
{
    printf "Enter your hostname (default=${HOSTNAME}): "
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
    printf "Enter your chosen language (default=$LANGUAGE): "
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
    printf "Enter your chosen keymap (default=$KEYMAP): "
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
    printf "Enter your chosen zoneinfo (default=$ZONEINFO): "
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
    echo "PASSWORD=$PASSWORD" >> $ENVFILE
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
    prompt_password
    prompt_hostname
    prompt_language
    prompt_keymap
    prompt_zoneinfo
    prompt_desktop_environment
    prompt_bootloader
    prompt_video_drivers
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

prompt_message()
{
    B=$(tput bold)
    N=$(tput sgr0)

    echo ""
    echo "${B}[  $1  ]${N}"
}

prompt_success()
{
    prompt_message "Setup finished! You can reboot now."
}

prompt_failure()
{
    prompt_message "Setup failed! Check errors before trying again."
    exit 1
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

parse_arguments()
{
    while [[ $# -gt 0 ]]
    do
        key=$1
        case $key in
            -d|--default)
                export INTERACTIVE=0
                shift # past argument
            ;;
            -k|--no-reboot)
                export AUTOREBOOT=0
                shift # past argument
            ;;
            *) # unknown option
                echo "Usage: $SCRIPTFILE [-d | --default] [-k | --no-reboot]"
                exit 1
            ;;
        esac
    done
}

main()
{
    # Check pre-install state
    check_mounted_drive
    parse_arguments $@

    # Install as script or interactively
    if [[ $INTERACTIVE == 1 ]]; then
        customize_env
    else
        prompt_message "Installing with defaults set in $ENVFILE..."
        prompt_password
    fi

    # Save data entered by the user
    export_environment

    # Install and verify
    install_system
    verify_installation

    # Message at end
    if [[ $? == 0 ]]; then
        prompt_success
    else
        prompt_failure
    fi

    # Auto-reboot
    if [[ $AUTOREBOOT == 1 ]]; then
        reboot_system
    fi
}

# Execute main
main $@
