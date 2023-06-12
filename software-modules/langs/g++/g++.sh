#!/bin/bash

#	g++.sh
#	Script to build the modular software package of GNU
#	Compiler Collection with only g++ compiler for huronOS.
#	It purges the unnecessary files on the FS to allow AUFS
#	add/del operations on the fly.
#	It includes the documentation for the C++ programming language.
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
NAME=g++
TARGET_DIR="/run/initramfs/memory/system/huronOS/software/langs/"

## Install software
apt update
apt install --yes --no-install-recommends $NAME
apt autoremove --yes

## Prepare final files
mkdir -p /usr/share/doc/reference/c++/
tar -xvzf reference.tar.gz --strip-components=1 -C /usr/share/doc/reference/c++/
cp ./c++-documentation.desktop /usr/share/applications/

## Create packed changes
savechanges /tmp/$NAME.hsm

## Clean package to maintain only relevant files
hsm2dir /tmp/$NAME.hsm
rm -rf /tmp/$NAME.hsm/var
rm -rf /tmp/$NAME.hsm/etc
rm -rf /tmp/$NAME.hsm/root
rm -rf /tmp/$NAME.hsm/home
rm -f /tmp/$NAME.hsm/usr/bin/*gcc*
dir2hsm /tmp/$NAME.hsm

cp /tmp/$NAME.hsm "$TARGET_DIR"
echo "Finished creating $NAME.hsm!"