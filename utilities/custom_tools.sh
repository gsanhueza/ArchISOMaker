#!/usr/bin/env bash

BASE_DIR=`dirname $(readlink -f $0)`
DETECTOR_PATH="${BASE_DIR}/utilities/detect_packages.sh"

# Whether to update cache every time, or keep what's available now.
UPDATE_CACHE=1

# Helper function to run make_*() only one time per architecture.
run_once() {
    if [[ ! -e ${WORK_DIR}/build.${1} ]]; then
        $1
        touch ${WORK_DIR}/build.${1}
    fi
}

# Create needed folders for make_local_repo
make_folder() {
    echo "Creating temporal root folder..."

    # Make root directory
    if [[ ! -e ${TEMP_MNT} ]]; then
        mkdir -p ${TEMP_MNT}
        echo "Creating temporal install root at ${TEMP_MNT}"
        mkdir -m 0755 -p "${TEMP_MNT}"/var/{cache/pacman/pkg,lib/pacman,log} ${TEMP_MNT}/{dev,run,etc}
        mkdir -m 1777 -p "${TEMP_MNT}"/tmp
        mkdir -m 0555 -p "${TEMP_MNT}"/{sys,proc}
    fi

    # Make repo folder
    if [[ ! -e ${PKG_CACHE_DIR} ]]; then
        mkdir -p ${PKG_CACHE_DIR}
    fi
}

# Pull packages from Internet
# See packages.sh
make_download() {
    echo "Downloading packages..."
    source $DETECTOR_PATH

    pacman -Syw --root ${TEMP_MNT} --cachedir ${PKG_CACHE_DIR} --noconfirm $ALL_PACKAGES
}

# Create Pacman DB
make_database() {
    echo "Creating package database..."

    n=0

    # If the command didn't run correctly, re-run. It solves the file-not-found error. Go figure.
    # We'll re-run the command up to 3 times.
    until [ $n -ge 3 ]
    do
        repo-add -R -n ${PKG_CACHE_DIR}/custom.db.tar.gz ${PKG_CACHE_DIR}/*pkg.tar.zst && break  # If command ran ok, don't re-run
        n=$[$n+1]
        sleep 1
    done
}

# Make local pkg database and repo only if needed
make_local_repo() {
    echo "Creating local repo..."

    run_once make_folder

    if (( UPDATE_CACHE )); then
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

    rm ${WORK_DIR} -rf
    rm ${TEMP_MNT} -rf
    chown $OWNER:$OWNER ${OUT_DIR}/*.iso -v
    mv ${OUT_DIR}/* .. -v
}
