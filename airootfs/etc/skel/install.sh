script_name=${0##*/}

install_system() {
    source /root/packages.sh
    PACKAGES=$BASE

    # KDE vs GNOME vs i3
    echo "*** Installing ${DESKTOP_ENV}... ***"
    if [ $DESKTOP_ENV == "KDE" ]
    then
        PACKAGES="$PACKAGES $KDE"
    elif [ $DESKTOP_ENV == "GNOME" ]
    then
        PACKAGES="$PACKAGES $GNOME"
    elif [ $DESKTOP_ENV == "i3" ]
    then
	PACKAGES="$PACKAGES $I3"
    fi

    # rEFInd vs GRUB
    echo "*** Installing ${BOOTLOADER}... ***"
    if [[ $BOOTLOADER == "refind" ]]
    then
        PACKAGES="$PACKAGES $REFIND"
    elif [[ $BOOTLOADER == "grub" ]]
    then
        PACKAGES="$PACKAGES $GRUB"
    fi

    # nVidia vs AMD vs VBox
    echo "*** Installing ${XORG_DRIVERS} drivers... ***"
    if [[ $XORG_DRIVERS == "nvidia" ]]
    then
        PACKAGES="$PACKAGES $NVIDIA"
    elif [[ $XORG_DRIVERS == "amd" ]]
    then
        PACKAGES="$PACKAGES $AMD"
    elif [[ $XORG_DRIVERS == "vbox" ]]
    then
        PACKAGES="$PACKAGES $VBOX"
    elif [[ $XORG_DRIVERS == "intel" ]]
    then
        PACKAGES="$PACKAGES $INTEL"
    fi

    # Installing here
    pacstrap /mnt $PACKAGES --cachedir=/root/pkg --needed

    genfstab -p -U /mnt > /mnt/etc/fstab
    cp /root/mirrorlist /mnt/etc/pacman.d/mirrorlist -v

    cp /root/env.sh /mnt/root -v
    cp /root/config.sh /mnt/root -v
    cp /root/yay_install.sh /mnt/root -v

    echo ""
    echo "*** Now configuring your system with $DESKTOP_ENV, $BOOTLOADER and $XORG_DRIVERS... ***"
    arch-chroot /mnt /bin/zsh -c "cd && ./config.sh && rm config.sh env.sh -f"
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

customize_env() {
    source /root/env.sh

    echo "I'll now ask for data needed to install your system."
    echo "If you leave it blank, it will just use the defaults set in the 'env.sh' file."
    echo ""

    # Name
    printf "Write your name (default=$USERNAME): "
    read ans
    case $ans in
        '')
            USERNAME="$USERNAME"
        ;;
        *)
            USERNAME=$ans
        ;;
    esac

    # Hostname
    printf "Write your hostname (default=${HOSTNAME}): "
    read ans
    case $ans in
        '')
            HOSTNAME="$HOSTNAME"
        ;;
        *)
            HOSTNAME=$ans
        ;;
    esac

    # Language
    printf "Write your chosen language (default=$LANGUAGE): "
    read ans
    case $ans in
        '')
            LANGUAGE="$LANGUAGE"
        ;;
        *)
            LANGUAGE=$ans
        ;;
    esac

    # Keymap
    printf "Write your chosen keymap (default=$KEYMAP): "
    read ans
    case $ans in
        '')
            KEYMAP="$KEYMAP"
        ;;
        *)
            KEYMAP=$ans
        ;;
    esac

    # Zoneinfo
    printf "Write your chosen zoneinfo (default=$ZONEINFO): "
    read ans
    case $ans in
        '')
            ZONEINFO="$ZONEINFO"
        ;;
        *)
            ZONEINFO=$ans
        ;;
    esac

    # Desktop environment
    echo "Choose your Desktop Environment (default=$DESKTOP_ENV)"
    printf "(1) KDE    (2) GNOME    (3) i3: "
    read ans
    case $ans in
        '')
            DESKTOP_ENV="$DESKTOP_ENV"
        ;;
        '1')
            DESKTOP_ENV="KDE"
        ;;
        '2')
            DESKTOP_ENV="GNOME"
        ;;
	'3')
	    DESKTOP_ENV="i3"
	;;
        *)
            echo "Wrong choice, halting now!"
            exit 1
        ;;
    esac

    # Bootloader
    echo "Choose your Bootloader (default=$BOOTLOADER)"
    printf "(1) rEFInd    (2) GRUB: "
    read ans
    case $ans in
        '')
            BOOTLOADER="$BOOTLOADER"
        ;;
        '1')
            BOOTLOADER="refind"
        ;;
        '2')
            BOOTLOADER="grub"
        ;;
        *)
            echo "Wrong choice, halting now!"
            exit 1
        ;;
    esac

    # Xorg Drivers
    echo "Choose your Graphic Drivers (default=$XORG_DRIVERS)"
    printf "(1) nVidia    (2) AMD    (3) VBox    (4) Intel: "
    read ans
    case $ans in
        '')
            XORG_DRIVERS="$XORG_DRIVERS"
        ;;
        '1')
            XORG_DRIVERS="nvidia"
        ;;
        '2')
            XORG_DRIVERS="amd"
        ;;
        '3')
            XORG_DRIVERS="vbox"
        ;;
        '4')
            XORG_DRIVERS="intel"
        ;;
        *)
            echo "Wrong choice, halting now!"
            exit 1
        ;;
    esac

    echo '' > /root/env.sh

    echo "export USERNAME=$USERNAME" >> /root/env.sh
    echo "export HOSTNAME=$HOSTNAME" >> /root/env.sh
    echo "export LANGUAGE=$LANGUAGE" >> /root/env.sh
    echo "export KEYMAP=$KEYMAP" >> /root/env.sh
    echo "export ZONEINFO=$ZONEINFO" >> /root/env.sh
    echo "export DESKTOP_ENV=$DESKTOP_ENV" >> /root/env.sh
    echo "export BOOTLOADER=$BOOTLOADER" >> /root/env.sh
    echo "export XORG_DRIVERS=$XORG_DRIVERS" >> /root/env.sh
}

check_mounted_drive() {
    MOUNTPOINT="/mnt"
    B=$(tput bold)
    N=$(tput sgr0)

    if [[ $(findmnt -M "$MOUNTPOINT") ]]; then
        echo "Drive mounted in $MOUNTPOINT."
    else
        echo "Drive is ${B}NOT MOUNTED!${N}"
        echo "Mount your drive in '$MOUNTPOINT' and re-run '$script_name' to install your system."
        exit 1
    fi
}

### Main

check_mounted_drive
printf "Do you wish to install now? (Y/n): "
read inst

case $inst in
    ''|'y'|'Y')
        printf "Do you want to use defaults? (See env.sh) (Y/n): "
        read defaults
        case $defaults in
            'n'|'N')
                customize_env
            ;;
        esac
        source /root/env.sh
        install_system
    ;;
    *)
        echo "Re-run '$script_name' to install your system."
    ;;
esac
