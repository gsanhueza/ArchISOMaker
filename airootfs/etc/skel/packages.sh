# Base system
MINIMAL="base linux linux-firmware"
ESSENTIAL="man-db man-pages pacman-contrib intel-ucode amd-ucode"
DEVELOPMENT="base-devel git"
DISKMGM="e2fsprogs dosfstools ntfs-3g"
CONSOLE="vim vim-airline vim-fugitive grml-zsh-config"
MULTIMEDIA="gstreamer alsa-utils mpv"
NETWORKING="networkmanager"
UTILS="xdg-user-dirs unrar p7zip"

_BASE="$MINIMAL $ESSENTIAL $DEVELOPMENT $DISKMGM $CONSOLE $MULTIMEDIA $NETWORKING $UTILS"

# Bootloaders
REFIND="refind"
GRUB="grub os-prober"

_BOOTLOADERS="$REFIND $GRUB"

# Base drivers
XORGFULL="xorg xorg-drivers"
XORGUTILS="xorg-server xorg-xinit xf86-input-libinput"

_XORG="$XORGFULL $XORGUTILS"

# Video mappings
NVIDIA="nvidia"
AMD="xf86-video-amdgpu"
VBOX="xf86-video-vmware virtualbox-guest-utils"
INTEL=""

_VIDEO="$NVIDIA $AMD $VBOX $INTEL"

# Desktop (GUI)
GNOME="gnome gnome-tweak-tool"
KDE="plasma konsole dolphin kate gwenview kolourpaint okular spectacle ark smplayer"
I3="i3 picom dmenu pulseaudio-alsa sddm xterm"
X11="xorg-twm xorg-xclock xterm"

_DESKTOPS="$GNOME $KDE $I3 $X11"

# Compilations
PACKAGES="$_BASE $XORGUTILS"
ALL="$_BASE $_BOOTLOADERS $_XORG $_VIDEO $_DESKTOPS"
