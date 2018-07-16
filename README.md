# ArchISOMaker
A custom Arch Linux ISO Maker (Just a bunch of scripts)

## Instructions

* Login as root
* Run the command
```bash
# ./build -v
```
* ???
* Profit!

Your ISO file will be in the parent of this folder.

## Relevant notes (ISO building)

This custom builder pulls the most updated ArchLinux packages before creating the ISO file, which implies that you need a working internet connection to pull these packages.

If your desired packages are already in `airootfs/etc/skel/pkg` (or you don't want to pull new packages from the Internet), edit `build.sh` and change the *UPDATECACHE* variable to 0.

If you want to update old packages, edit `build.sh` and change the *UPDATECACHE* variable to 1. (This is the default behaviour.)
Then, this script will pull the packages (specified in `airootfs/etc/skel/packages.sh`), create a DB and build your ISO.

## Relevant notes (ISO installation)

The idea behind this ISO maker is to provide a way to create your own ArchLinux installation ISO file, which will have a database and ArchLinux packages embedded in it.
In other words, this implies that the ISO file that you created using `build.sh` will allow you to install ArchLinux on any computer, even **without** internet access.
The created ISO will offer you to automatize your installation (although you can do it manually too, if that's what you want).

The automated installer will use data in the `env.sh` file (you can edit it manually too), or interactively through the `install.sh` installation script.

I'm currently offering to install:

### Desktop environments
* KDE
* GNOME
* i3

### Bootloaders
* rEFInd
* GRUB

### Graphic drivers
* nVidia
* AMD
* VirtualBox
* Intel

