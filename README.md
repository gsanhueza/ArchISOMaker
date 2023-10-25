# ArchISOMaker

A custom Arch Linux ISO Maker (Just a bunch of scripts).

## Instructions

### Retrieving this repository

* Clone this repo.
* Initialize submodules (`git submodule init`)
* Update submodules (`git submodule update`)

### Generating the ISO file

* Run `$ sudo ./build.sh -v`
* Get the ISO file in the *parent* directory of this repository.

### Updating this repository (and the submodule)

* Run `git pull --recurse-submodules`

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
The embedded packages are detected using `detect_packages.sh`, will be
downloaded in `airootfs/root/pkg`, and will be automatically updated when
you run `build.sh` (the ISO-building script).

If you don't want to auto-update the packages when running the script,
edit `customtools.sh` and change the *UPDATECACHE* variable to 0.

## Testing your ISO

The generated ISO comes with virtualbox drivers, so you can setup a VirtualBox
machine and run your ISO there.

Alternatively, `archiso` provides with a convenient method that uses QEMU:

- `run_archiso -i path/to/an/arch.iso` to run as BIOS
- `run_archiso -u -i path/to/an/arch.iso` to run as UEFI

## Installing your system

Burn the generated ISO to a DVD or an USB stick.
When you boot it, you'll be greeted by a welcome message that hints you the
necessary steps that you have to follow, so you can run the installation
script (`install.sh`).

##Offline Installation Keyring Issue:

Before running `install.sh` first run the following command otherwise all package installs will fail.
```
sudo pacman-key --init; sudo pacman-key --populate; sudo pacman-key --lsign cachyos
```

