#!/bin/bash

#	firmware.sh
#	Script to build the firmware huronOS System Layer (.hsl)
#	for huronOS image. It packs the huronOS' selection
#	of free, open and private firmware to improve the
#	performance of the distribution over several hardware.
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

## Get the dependencies and replace every new line with a space
mapfile -t DEPENDENCIES <dependencies.txt

apt update

apt install --yes --no-install-recommends "${DEPENDENCIES[@]}"
apt autoremove --yes --purge

## Install the nvidia drivers
cd nvidia
./install-nvidia-drivers.sh

savechanges /tmp/02-firmware.hsl
cp /tmp/02-firmware.hsl /run/initramfs/memory/system/huronOS/base --verbose
