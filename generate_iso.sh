compile_aur_helper() {
    echo "+++ We're compiling the yay AUR helper +++"
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -s

    echo "+++ AUR helper compiled. Enter your password to continue. +++"
    sudo mv *pkg.tar* ../airootfs/etc/skel/pkg/ -v
    cd ..
    rm -rf yay-bin
}

build_iso() {
    sudo ./build.sh $@
}

# Run script
if [[ ${EUID} -ne 0 ]]; then
    compile_aur_helper
    build_iso $@
else
    echo "This script must be started as a standard user."
    exit 1
fi

