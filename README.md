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

If you already have what you want (i.e. the `airootfs/etc/skel/pkg` folder exists and has a custom.db.tar.gz file too) then this script will just build your ISO.
Else, this script will pull the packages (specified in `build.sh`), create a DB and build your ISO.

If you already used this script, but want to update the packages to create a new ISO, please delete the `airootfs/etc/skel/pkg` folder and run `build.sh -v` to allow the script to create the *pkg* folder again.

## Relevant notes (ISO installation)

The idea behind this ISO maker is to provide a way to create your own ArchLinux installation ISO file, which will have a database and ArchLinux packages embedded in it.
In other words, this implies that the ISO file that you created using `build.sh` will allow you to install ArchLinux on any computer, even **without** internet access.
The created ISO will offer you to automatize your installation (although you can do it manually too, if that's what you want).

The automatized process will install straightforwardly by reading an `env.sh` file that you can edit manually, or interactively through the `install.sh` installation script.

I'm currently offering to install:

### Desktop environments
* KDE
* GNOME

### Bootloaders
* rEFInd
* GRUB

### Graphic drivers
* nVidia
* AMD (Legacy)
* VirtualBox
* Intel

