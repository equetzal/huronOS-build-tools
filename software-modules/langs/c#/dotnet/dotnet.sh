#!/bin/bash

#	mono.sh
#	Script to build the modular software package of Microsoft .NET
#	SDK.
#	It purges the unnecessary files on the FS to allow AUFS
#	add/del operations on the fly.
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
NAME=dotnet
TARGET_DIR="/run/initramfs/memory/system/huronOS/software/langs/"

## Install microsoft signature
wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

## Install software
apt update
apt install --yes --no-install-recommends dotnet-sdk-6.0
apt autoremove --yes

## Create packed changes
savechanges /tmp/$NAME.hsm

## Clean package to maintain only relevant files
hsm2dir /tmp/$NAME.hsm
rm -rf /tmp/$NAME.hsm/var
rm -rf /tmp/$NAME.hsm/root
rm -rf /tmp/$NAME.hsm/home
rm -rf /tmp/$NAME.hsm/etc
rm -rf /tmp/$NAME.hsm/etc/apt
rm -rf /tmp/$NAME.hsm/etc/ssl
rm -rf /tmp/$NAME.hsm/etc/ld.so.cache
rm -rf /tmp/$NAME.hsm/etc/ca-certificates
rm -rf /tmp/$NAME.hsm/usr/sbin
rm -rf /tmp/$NAME.hsm/usr/share/gnome
rm -rf /tmp/$NAME.hsm/usr/share/mime
rm -rf /tmp/$NAME.hsm/usr/share/icons/hicolor/icon-theme.cache
rm -rf /tmp/$NAME.hsm/usr/share/applications/bamf-2.index
rm -rf /tmp/$NAME.hsm/usr/share/applications/mimeinfo.cache
find /tmp/$NAME.hsm/
dir2hsm /tmp/$NAME.hsm

mkdir -p "$TARGET"
cp /tmp/$NAME.hsm "$TARGET_DIR"
echo "Finished creating $NAME.hsm!"
