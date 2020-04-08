BASE="base base-devel linux linux-firmware man-db man-pages vim grml-zsh-config intel-ucode amd-ucode alsa-utils xf86-input-libinput"
UTILS="pacman-contrib vim-airline vim-fugitive gstreamer mpv ttf-hack git unrar p7zip networkmanager"
XORG="xorg xorg-drivers xorg-server xorg-xinit"

GNOME="gnome gnome-tweak-tool"
KDE="plasma kdebase kdegraphics ark smplayer"
I3="i3 compton dmenu pulseaudio-alsa sddm xterm"

REFIND="refind-efi"
GRUB="grub os-prober"

NVIDIA="nvidia bumblebee"
AMD="xf86-video-amdgpu"
VBOX="virtualbox-guest-utils"
INTEL=""

ALL="$BASE $UTILS $XORG $GNOME $KDE $I3 $REFIND $GRUB $NVIDIA $AMD $VBOX $INTEL"

