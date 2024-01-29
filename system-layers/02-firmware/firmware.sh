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

chvt 1 || true

apt update

## Accept the License terms before doing install
echo firmware-ipw2x00 firmware-ipw2x00/license/accepted boolean true | debconf-set-selections
echo firmware-ivtv firmware-ivtv/license/accepted boolean true | debconf-set-selections

## Set to non-interactive to avoid being prompt
export DEBIAN_FRONTEND=noninteractive
apt install --yes --no-install-recommends "${DEPENDENCIES[@]}"
apt autoremove --yes --purge

savechanges /tmp/02-firmware.hsl
cp /tmp/02-firmware.hsl /run/initramfs/memory/system/huronOS/base --verbose
