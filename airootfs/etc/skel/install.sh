install_system() {
    PACKAGES="base base-devel yaourt vim grml-zsh-config gstreamer smplayer xorg-server cantarell-fonts xorg-xinit xf86-input-libinput intel-ucode alsa-utils"

    # KDE vs GNOME
    echo "*** Installing ${DESKTOP_ENV}... ***"
    if [ $DESKTOP_ENV == "KDE" ]
    then
        PACKAGES="$PACKAGES plasma kdebase kde-l10n-es"
    elif [ $DESKTOP_ENV == "GNOME" ]
    then
        PACKAGES="$PACKAGES gnome gnome-tweak-tool"
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
    echo "*** Installing ${XORG_DRIVERS} drivers... ***"
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
    cp /root/pacman_on_installation.conf /mnt/etc/pacman.conf -v
    cp /root/mirrorlist /mnt/etc/pacman.d/mirrorlist -v

    cp /root/env.sh /mnt/root -v
    cp /root/config.sh /mnt/root -v

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
}

customize_env() {
    source /root/env.sh

    echo "I'll now ask for data needed to install your system."
    echo "If you leave it blank, it will just use defaults. (See env.sh)."
    echo ""

    # Name
    printf "Write your name (default=${USERNAME}): "
    read ans
    case $ans in
        '')
            USERNAME="${USERNAME}"
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
            HOSTNAME="${HOSTNAME}"
        ;;
        *)
            HOSTNAME=$ans
        ;;
    esac

    # Language
    printf "Write your chosen language (default=${LANGUAGE}): "
    read ans
    case $ans in
        '')
            LANGUAGE="${LANGUAGE}"
        ;;
        *)
            LANGUAGE=$ans
        ;;
    esac

    # Desktop environment
    echo "Choose your Desktop Environment (default=KDE)"
    printf "(1) KDE    (2) GNOME: "
    read ans
    case $ans in
        ''|'1')
            DESKTOP_ENV="KDE"
        ;;
        '2')
            DESKTOP_ENV="GNOME"
        ;;
        *)
            echo "Wrong choice, halting now!"
            exit 1
        ;;
    esac

    # Bootloader
    echo "Choose your Bootloader (default=rEFInd)"
    printf "(1) rEFInd    (2) GRUB: "
    read ans
    case $ans in
        ''|'1')
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
    echo "Choose your Graphic Drivers (default=nvidia)"
    printf "(1) nVidia    (2) AMD    (3) VBox    (4) Intel: "
    read ans
    case $ans in
        ''|'1')
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

    echo "export USERNAME=\"${USERNAME}\"" >> /root/env.sh
    echo "export HOSTNAME=\"${HOSTNAME}\"" >> /root/env.sh
    echo "export LANGUAGE=\"${LANGUAGE}\"" >> /root/env.sh
    echo "export DESKTOP_ENV=\"${DESKTOP_ENV}\"" >> /root/env.sh
    echo "export BOOTLOADER=\"${BOOTLOADER}\"" >> /root/env.sh
    echo "export XORG_DRIVERS=\"${XORG_DRIVERS}\"" >> /root/env.sh
}

### Main

printf "Do you wish to install now? (Y/n): "
read inst

case $inst in
    ''|'y'|'Y')
        printf "Do you want to use defaults? (Y/n): "
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
        echo "Re-run 'install.sh' to install your system."
    ;;
esac
