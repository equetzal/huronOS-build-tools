#!/bin/bash

#	eclipse.sh
#	Script to build the modular software package of Eclipse
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
NAME=eclipse

## Prepare final files
cp ./$NAME.desktop /usr/share/applications/

## Install software
cp eclipse-inst-jre-linux64.tar.gz /tmp/
pushd /tmp/
	tar -xf eclipse-inst-jre-linux64.tar.gz
	cd eclipse-installer/
	su contestant -c "echo \$! && ./eclipse-inst"
popd

## Create packed changes
savechanges /tmp/$NAME.hsm

## Clean package to maintain only relevant files
hsm2dir /tmp/$NAME.hsm
rm -rf /tmp/$NAME.hsm/var
rm -rf /tmp/$NAME.hsm/root
rm -rf /tmp/$NAME.hsm/home/contestant/.cache
rm -rf /tmp/$NAME.hsm/home/contestant/.config
rm -rf /tmp/$NAME.hsm/home/contestant/.local/share
rm -rf /tmp/$NAME.hsm/home/contestant/.xsession*
rm -rf /tmp/$NAME.hsm/home/contestant/.X*
dir2hsm /tmp/$NAME.hsm

cp /tmp/$NAME.hsm /run/initramfs/memory/system/huronOS/programming/
echo "Finished creating $NAME.hsm!"
