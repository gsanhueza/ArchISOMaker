#!/usr/bin/env bash
#
# SPDX-License-Identifier: GPL-3.0-or-later

set -e -u

# Warning: customize_airootfs.sh is deprecated! Support for it will be removed in a future archiso version.

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

mv /root/pacman_on_iso.conf /etc/pacman.conf
mv /root/zshrc /root/.zshrc

sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
