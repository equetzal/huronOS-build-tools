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

KERNEL_HEADERS_BASE="/usr/lib/modules/$(uname -r)"

LINUX_PATH="/mnt/ubuntu/home/dt3264/huronOS/kernel-stuff-6.1.31/linux"

# Link the kernel source to where the headers should be
mkdir -p "$KERNEL_HEADERS_BASE"
ln -vnfs "$LINUX_PATH" "$KERNEL_HEADERS_BASE/build"
ln -vnfs "$LINUX_PATH" "$KERNEL_HEADERS_BASE/source"
