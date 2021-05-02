# ArchISOMaker
A custom Arch Linux ISO Maker (Just a bunch of scripts)

## Instructions

* Clone this repo.
* Run `$ sudo ./build.sh -v`
* ???
* Profit! Your ISO file will be in the parent of this folder.

## Introduction

This is a script collection based on Archiso, which allows you to build your
own Arch Linux ISO. The main difference from upstream is that this variant
pulls the most updated ArchLinux packages and embeds them in the ISO file.
This means that you do not need to have an internet connection anymore when
*installing* Arch Linux from this ISO.

Additionally, a custom installation script is also embedded in the ISO, so you
can install a *standard* version of Arch Linux non-interactively . Of course, you
are not forced to use it, if you want to manually install Arch Linux following the
wiki instructions.

## Building your ISO

You need to have `archiso` installed in your system to use this script, and a
working internet connection to pull the packages that we'll embed into the ISO.
The embedded packages are specified in `airootfs/root/packages.sh`, will be
downloaded in `airootfs/root/pkg`, and will be automatically updated when
you run `build.sh` (the ISO-building script).

If you don't want to auto-update the packages when running the script,
edit `customtools.sh` and change the *UPDATECACHE* variable to 0.

## Installing your system

Burn the generated ISO to a DVD or an USB stick.
When you boot it, you'll be greeted by a welcome message that hints you the
necessary steps that you have to follow, so you can run the installation
script (`install.sh`).

### Relevant information

The installation script (`install.sh`) asks for your data by default, and auto-reboots
when the installation has been successful.
To change this behavior, use the arguments `-d` and/or `-k`:

- `./install.sh -d`: Minimizes user interaction with the script by only asking for
a password to the installed system, and uses the remaining information
from `env.sh` as default. **Only use this argument after manually editing `env.sh`**.
- `./install.sh -k`: Keeps the live system on, avoiding the auto-reboot step.
Useful if you want to do post-install tasks before rebooting into your newly-installed system.

### Script descriptions

Each script file plays a particular role:

- `install.sh`: The main installation script. By default, it will ask you for information needed
to install Arch Linux.
- `env.sh`: The environment script that stores the installation/setup information.
- `config.sh`: A configuration script that inside *chroot*, after installing the
packages. It uses the information stored in `env.sh`.
- `packages.sh`: A "database" of needed packages depending on your choices in
the installation script.
- `printer.sh`: A printer script, mostly used to print colored messages.

## Available packages by default

### Desktop environments
* KDE (Plasma)
* GNOME (GNOME Shell)
* i3 (Window manager)
* X11 (Minimal Xorg)

### Bootloaders
* rEFInd
* GRUB

### Graphic drivers
* nVidia
* AMD
* VirtualBox
* Intel
