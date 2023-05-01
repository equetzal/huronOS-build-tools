#!/bin/bash

#	custom.sh
#	Script to build the custom huronOS System Layer (.hsl)
#	for huronOS image. For now, it prepare the files for changing
#   the password during installation.
#   It gets the shadow file used in the installer
#   in case someone wants to change the password
#
#	Copyright (C) 2022, huronOS Project:
#		<http://huronos.org>
#
#	Licensed under the GNU GPL Version 2
#		<http://www.gnu.org/licenses/gpl-2.0.html>
#
#	Authors:
#		Daniel Cerna <dcerna@huronos.org>

set -xe
# Create a fake root
mkdir -p "squashfs-root/etc/"
# Copy the shadow file to the fake root
cp "/etc/shadow" "squashfs-root/etc/shadow"
# Squash the fake root into a System Layer
mksquashfs "squashfs-root" /tmp/05-custom.hsl
# Copy the System Layer to the USB next to the other System Layers
cp /tmp/05-custom.hsl /run/initramfs/memory/system/huronOS/base --verbose
# Erases the fake root
rm -r "squashfs-root"
