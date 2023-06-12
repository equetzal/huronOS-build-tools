#!/bin/bash

#	vim.sh
#	Script to build the modular software package of Vim
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
#		Enya Quetzalli <equetzal@huronos.org>

set -xe
NAME=gdb
TARGET_DIR="/run/initramfs/memory/system/huronOS/software/debuggers/"

## Install software
apt update
apt install --yes --no-install-recommends $NAME
apt autoremove --yes

## Create packed changes
savechanges /tmp/$NAME.hsm

## Clean package to maintain only relevant files
hsm2dir /tmp/$NAME.hsm
cd /tmp/gdb.hsm
find ./ ! -path "./etc/gdb*" ! -path "./usr/share/man*" ! -path "./usr/share/gdb*" ! -path "./usr/share/doc*" ! -path "./usr/include/gdb*" ! -path "./usr/bin/gdb*" -delete || true
cd ..
dir2hsm /tmp/$NAME.hsm

cp /tmp/$NAME.hsm "$TARGET_DIR"
echo "Finished creating $NAME.hsm!"
