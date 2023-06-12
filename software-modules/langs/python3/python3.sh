#!/bin/bash

#	python3.sh
#	Script to build the modular software package of Python 3 for huronOS.
#	It purges the unnecessary files on the FS to allow AUFS
#	add/del operations on the fly.
#	It includes the documentation for the Python 3 programming language.
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
NAME=python3
TARGET_DIR="/run/initramfs/memory/system/huronOS/software/langs/"

## Install software
# Python3 is special case, it is dependency for budgie, so we will need to manage it with permissions.

## Prepare final files
mkdir -p /usr/share/doc/reference/$NAME/
tar -xvzf reference.tar.gz --strip-components=1 -C /usr/share/doc/reference/$NAME/
cp ./python3-documentation.desktop /usr/share/applications/

## Create packed changes
savechanges /tmp/$NAME.hsm

## Clean package to maintain only relevant files
hsm2dir /tmp/$NAME.hsm
rm -rf /tmp/$NAME.hsm/var
rm -rf /tmp/$NAME.hsm/home
rm -rf /tmp/$NAME.hsm/root
rm -rf /tmp/$NAME.hsm/etc
dir2hsm /tmp/$NAME.hsm

cp /tmp/$NAME.hsm "$TARGET_DIR"
echo "Finished creating $NAME.hsm!"