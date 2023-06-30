#!/bin/bash

#	nvidia-non-free.sh
#	Script to build the in-between firmware huronOS System Layer (.hsl)
#	for huronOS image. It packs the propietary nvidia drivers
#	for a more stable experience of the distribution.
#
#	Copyright (C) 2022, huronOS Project:
#		<http://huronos.org>
#
#	Licensed under the GNU GPL Version 2
#		<http://www.gnu.org/licenses/gpl-2.0.html>
#
#	Authors:
#		Enya Quetzalli <equetzal@huronos.org>

set -xe

TMP_DIR="/tmp/lab-$$"
MAIN_PATH="$(dirname "$(readlink -f "$0")")"
mapfile -t DEPENDENCIES <dependencies.txt
apt update
apt install --yes --no-install-recommends "${DEPENDENCIES[@]}"

mkdir -p "$TMP_DIR"
cd "$TMP_DIR"

git clone --depth 1 --branch v6.1.31 https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git

cd linux
cp "$MAIN_PATH/Module.symvers" Module.symvers
cp "$MAIN_PATH/huronos.config" .config
make olddefconfig && make prepare

apt remove --yes --no-install-recommends "${DEPENDENCIES[@]}"
apt autoremove --yes --purge

## Disable nouveau
# cp nvidia-installer-disable-nouveau.conf /etc/modprobe.d/nvidia-installer-disable-nouveau.conf

savechanges /tmp/02-nvidia-non-free.hsl
cp /tmp/02-nvidia-non-free.hsl /run/initramfs/memory/system/huronOS/base --verbose
