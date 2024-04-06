#!/usr/bin/env bash

# Check `airootfs/root/ArchScripts/recipes` for the recipe files
# whose packages you don't want embedded in the ISO, and
# separate them with spaces.
# E.g.:
#   BANNED_RECIPES="gnome.sh grub.sh nvidia.sh"

# Useful to reduce the final ISO size, but keep in mind
# that if you try to install ArchLinux with a recipe that
# you banned, the packages will not be there, and the
# installation will fail.

BANNED_RECIPES=""
