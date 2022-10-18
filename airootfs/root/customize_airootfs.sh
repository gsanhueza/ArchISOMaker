#!/usr/bin/env bash
#
# SPDX-License-Identifier: GPL-3.0-or-later

set -e -u

# Warning: customize_airootfs.sh is deprecated! Support for it will be removed in a future archiso version.

# Generate US locale
sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

# Enable mirrorlists
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist

# Avoid running reflector
systemctl mask reflector.service

# Enable NetworkManager
systemctl enable NetworkManager.service

