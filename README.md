# ArchISOMaker

A custom Arch Linux ISO Maker.

## Instructions (Generating the ISO file)

* Run `$ sudo ./build.sh -v`
* Get the ISO file in the *parent* directory of this repository.

## Description

This is a script collection based on [archiso](https://gitlab.archlinux.org/archlinux/archiso/), which allows you to build your own Arch Linux ISO. The main difference from upstream is that this variant pulls the most updated ArchLinux packages and embeds them in the ISO file. This means that you do not need to have an internet connection anymore when *installing* Arch Linux from this ISO.

Additionally, a custom installation script is also embedded in the ISO, so you can install a *standard* version of Arch Linux non-interactively . Of course, you are not forced to use it, if you want to manually install Arch Linux following the wiki instructions.

## Requirements

You need to have `archiso` installed to be able to use this.

If you are already using ArchLinux and you want to create an ISO for future usage, you can install it with `sudo pacman -S archiso`.

If you are using another distribution, you can try installing `archiso` using the link in the description, or use either `systemd-nspawn` or `distrobox` to bootstrap a minimal ArchLinux installation and cloning this repository inside.

If you come from Windows and you want to make an updated ISO with this tool, you can try using [Arch-WSL](https://github.com/VSWSL/Arch-WSL) and cloning this repository inside.

## Checking out the installation scripts

The installation scripts are found in a separate repository at https://github.com/gsanhueza/ArchScripts, which is automatically cloned when running the `build.sh` script for the first time, and automatically updated in subsequent executions of the script.

## Building your ISO

You need to have `archiso` installed in your system to use this script, and a working internet connection to pull the packages that we'll embed into the ISO. The embedded packages are detected using `utilities/detect_packages.sh`, will be downloaded in `airootfs/root/pkg`, and will be automatically updated when you run `build.sh` (the ISO-building script).

If you don't want to auto-update the packages when running the script, edit `utilities/custom_tools.sh` and change the *UPDATE_CACHE* variable to 0.

## Testing your ISO

The generated ISO comes with virtualbox drivers, so you can setup a VirtualBox machine and run your ISO there.

Alternatively, `archiso` provides a convenient method that uses QEMU:

- `run_archiso -i path/to/an/arch.iso` to run as BIOS.
- `run_archiso -u -i path/to/an/arch.iso` to run as UEFI.

## Installing your system

Burn the generated ISO to a DVD or an USB stick. When you boot it, you'll be greeted by a welcome message that shows you the necessary steps that you have to follow, so you can run the installation script (`install.sh`).
