#!/bin/bash

script_path=$(readlink -f ${0%/*})
source "$script_path/airootfs/etc/skel/packages.sh"

# Custom variables
NEWROOTLOC="$script_path/TEMPMNT"
PKGDBLOC="$script_path/airootfs/etc/skel/pkg"
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
    # Make root directory
    if [[ ! -e $NEWROOTLOC ]]; then
        mkdir -p $NEWROOTLOC
        echo "Creating temporal install root at ${NEWROOTLOC}"
        mkdir -m 0755 -p "$NEWROOTLOC"/var/{cache/pacman/pkg,lib/pacman,log} $NEWROOTLOC/{dev,run,etc}
        mkdir -m 1777 -p "$NEWROOTLOC"/tmp
        mkdir -m 0555 -p "$NEWROOTLOC"/{sys,proc}
    fi

    # Make repo folder
    if [[ ! -e $PKGDBLOC ]]; then
        mkdir -p $PKGDBLOC
    fi
}

# Pull packages from Internet
# See packages.sh
make_download() {
    pacman -Syw --root $NEWROOTLOC --cachedir $PKGDBLOC --noconfirm $ALL
}

# Create Pacman DB
make_database() {
    n=0

    # If the command didn't run correctly, re-run. It solves the file-not-found error. Go figure.
    # We'll re-run the command up to 5 times.
    until [ $n -ge 5 ]
    do
        repo-add -R -n $PKGDBLOC/custom.db.tar.gz $PKGDBLOC/*pkg.tar* && break  # If commmand ran ok, don't re-run
        n=$[$n+1]
        sleep 1
    done
}

# Make local pkg database and repo only if needed
make_local_repo() {
    run_once make_folder

    if (( UPDATECACHE )); then
        run_once make_download
        run_once make_database
    fi
    sync

    echo ""
    echo "Local repo is ready!"
}

# Clean-up
clean_up() {
    OWNER=${SUDO_USER:-$USER}

    rm work/ -rf
    rm $NEWROOTLOC -rf
    chown $OWNER out/* -v
    mv out/* ..
}
