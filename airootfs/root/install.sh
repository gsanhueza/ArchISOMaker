#!/bin/bash

INTERACTIVE=1

SCRIPTFILE=${0##*/}
PRINTERFILE="printer.sh"
PKGFILE="packages.sh"
ENVFILE="env.sh"
CONFFILE="config.sh"

source $PRINTERFILE
source $ENVFILE
source $PKGFILE

select_desktop_environment()
{
    # KDE vs GNOME vs i3 vs X11
    print_message "Selecting ${DESKTOP_ENV}..."

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
    print_message "Selecting ${BOOTLOADER}..."

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
    print_message "Selecting ${XORG_DRIVERS} drivers..."

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
    print_message "Installing packages..."
    pacstrap -C /root/pacman_on_iso.conf /mnt $PACKAGES --cachedir=/root/pkg --needed
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
    cp $PRINTERFILE /mnt/root -v
    cp yay_install.sh /mnt/root -v
}

configure_system()
{
    print_warning ">>> Configuring your system with $DESKTOP_ENV, $BOOTLOADER and $XORG_DRIVERS... <<<"
    arch-chroot /mnt /bin/zsh -c "cd && ./$CONFFILE && rm $CONFFILE $ENVFILE -f"
}

prompt_username()
{
    print_trailing "Enter your name (default=$USERNAME): "
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
    print_trailing "Enter your password (default=$PASSWORD): "
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
    print_trailing "Enter your hostname (default=${HOSTNAME}): "
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
    print_trailing "Enter your chosen language (default=$LANGUAGE): "
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
    print_trailing "Enter your chosen keymap (default=$KEYMAP): "
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
    print_trailing "Enter your chosen zoneinfo (default=$ZONEINFO): "
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
    print_light "Choose your Desktop Environment (default=$DESKTOP_ENV)"
    print_trailing "(1) KDE    (2) GNOME    (3) i3    (4) X11: "
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
            print_failure "Wrong choice, halting now!"
            exit 1
        ;;
    esac
}

prompt_bootloader()
{
    print_light "Choose your Bootloader (default=$BOOTLOADER)"
    print_trailing "(1) rEFInd    (2) GRUB: "
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
            print_failure "Wrong choice, halting now!"
            exit 1
        ;;
    esac
}

prompt_video_drivers()
{
    print_light "Choose your Graphic Drivers (default=$XORG_DRIVERS)"
    print_trailing "(1) nVidia    (2) AMD    (3) VBox    (4) Intel: "
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
            print_failure "Wrong choice, halting now!"
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
    print_message "This installation script will ask for some data before installing.\n"

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
        print_success "Drive mounted in $MOUNTPOINT."
    else
        print_failure "Drive is NOT MOUNTED!"
        print_warning "Mount your drive in '$MOUNTPOINT' and re-run '$SCRIPTFILE' to install your system."
        exit 1
    fi
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
    [[ ! -f /mnt/root/$CONFFILE && ! -f /mnt/root/$ENVFILE && ! -f /mnt/root/$PRINTERFILE ]]
}

parse_arguments()
{
    while [[ $# -gt 0 ]]
    do
        key=$1
        case $key in
            -d|--direct)
                export INTERACTIVE=0
                shift # past argument
            ;;
            -k|--no-reboot)
                export AUTOREBOOT=0
                shift # past argument
            ;;
            *) # unknown option
                print_failure "Usage: $SCRIPTFILE [-d | --direct] [-k | --no-reboot]"
                exit 1
            ;;
        esac
    done
}

main()
{
    # Check pre-install state
    parse_arguments $@
    check_mounted_drive

    # Install as script or interactively
    if [[ $INTERACTIVE == 1 ]]; then
        customize_env
    else
        print_warning "Installing with defaults set in $ENVFILE..."
        prompt_password
    fi

    # Save data entered by the user
    export_environment

    # Install and verify
    install_system
    verify_installation

    # Message at end
    if [[ $? == 0 ]]; then
        print_success "Installation finished! You can reboot now."
    else
        print_failure "Installation failed! Check errors before trying again."
        exit 1
    fi
}

# Execute main
main $@
