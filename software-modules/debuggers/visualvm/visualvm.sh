#!/bin/bash

#	visualvm.sh
#	Script to build the modular software package of visualvm
#	for huronOS. It purges the unnecessary files on the FS
#	to allow AUFS add/del operations on the fly.
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
NAME=visualvm
TARGET_DIR="/run/initramfs/memory/system/huronOS/software/debuggers/"

## In this particular script, given that visualvm depends on java but java cannot be installed directly in the dependencies,
## it is required to create a temp layer installing the remaining dependencies related to java before actually installing visualvm.

## Install software
apt update
apt install --yes --no-install-recommends $NAME
apt autoremove --yes

## Prepare final files
cp ./$NAME.desktop /usr/share/applications/

## Create packed changes
savechanges /tmp/$NAME.hsm

## Clean package to maintain only relevant files
hsm2dir /tmp/$NAME.hsm
cd /tmp/$NAME.hsm
find . ! -path "./usr/share/visualvm*" ! -path "./usr/share/man*" ! -path "./usr/share/lintian*" ! -path "./usr/share/icons*" ! -path "./usr/share/doc*" ! -path "./usr/bin*" ! -path "./etc/visualvm*"
cd ..
dir2hsm /tmp/$NAME.hsm

cp /tmp/$NAME.hsm "$TARGET_DIR"
echo "Finished creating $NAME.hsm!"
