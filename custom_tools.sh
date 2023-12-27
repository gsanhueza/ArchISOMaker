#!/bin/bash

script_path=$(readlink -f ${0%/*})

# Custom variables
work_dir="work"
out_dir="out"
temp_mnt="${script_path}/TEMPMNT"
custom_pkg_dir="${script_path}/airootfs/root/pkg"
UPDATECACHE=1

# Helper function to run make_*() only one time per architecture.
run_once() {
    if [[ ! -e ${work_dir}/build.${1} ]]; then
        $1
        touch ${work_dir}/build.${1}
    fi
}

# Create needed folders for make_local_repo
make_folder() {
    echo "Creating temporal root folder..."

    # Make root directory
    if [[ ! -e ${temp_mnt} ]]; then
        mkdir -p ${temp_mnt}
        echo "Creating temporal install root at ${temp_mnt}"
        mkdir -m 0755 -p "${temp_mnt}"/var/{cache/pacman/pkg,lib/pacman,log} ${temp_mnt}/{dev,run,etc}
        mkdir -m 1777 -p "${temp_mnt}"/tmp
        mkdir -m 0555 -p "${temp_mnt}"/{sys,proc}
    fi

    # Make repo folder
    if [[ ! -e ${custom_pkg_dir} ]]; then
        mkdir -p ${custom_pkg_dir}
    fi
}

# Pull packages from Internet
# See packages.sh
make_download() {
    echo "Downloading packages..."
    source "detect_packages.sh"

    pacman -Syw --root ${temp_mnt} --cachedir ${custom_pkg_dir} --noconfirm $ALL_PACKAGES
}

# Create Pacman DB
make_database() {
    echo "Creating package database..."

    n=0

    # If the command didn't run correctly, re-run. It solves the file-not-found error. Go figure.
    # We'll re-run the command up to 3 times.
    until [ $n -ge 3 ]
    do
        repo-add -R -n ${custom_pkg_dir}/custom.db.tar.gz ${custom_pkg_dir}/*pkg.tar.zst && break  # If command ran ok, don't re-run
        n=$[$n+1]
        sleep 1
    done
}

# Make local pkg database and repo only if needed
make_local_repo() {
    echo "Creating local repo..."

    run_once make_folder

    if (( UPDATECACHE )); then
        run_once make_download
        run_once make_database
    fi
    sync

    echo ""
    echo "Local repo is ready!"
}

# Cleaning duties
wrap_up() {
    echo "Wrapping up..."

    OWNER=${SUDO_USER:-$USER}

    rm ${work_dir} -rf
    rm ${temp_mnt} -rf
    chown $OWNER:$OWNER ${out_dir}/*.iso -v
    mv ${out_dir}/* .. -v
}
