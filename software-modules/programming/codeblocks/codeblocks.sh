#!/bin/bash

#	codeblocks.sh
#	Script to build the modular software package of Codeblocks
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

## Install software
apt update
apt install --yes --no-install-recommends codeblocks
apt autoremove --yes

## Prepare final files
cp ./codeblocks.desktop /usr/share/applications/

## Create packed changes
savechanges /tmp/codeblocks.hsm

## Clean package to maintain only relevant files
hsm2dir /tmp/codeblocks.hsm
rm -rf /tmp/codeblocks.hsm/var
rm -rf /tmp/codeblocks.hsm/etc
rm -rf /tmp/codeblocks.hsm/root
rm -rf /tmp/codeblocks.hsm/home
rm -rf /tmp/codeblocks.hsm/usr/share/mime
rm -rf /tmp/codeblocks.hsm/usr/share/gnome
rm -rf /tmp/codeblocks.hsm/usr/share/metainfo
rm -rf /tmp/codeblocks.hsm/usr/share/lintian
rm -rf /tmp/codeblocks.hsm/usr/share/icons
rm -rf /tmp/codeblocks.hsm/usr/share/applications/bamf-2.index
rm -rf /tmp/codeblocks.hsm/usr/share/applications/mimeinfo.cache
dir2hsm /tmp/codeblocks.hsm

cp /tmp/codeblocks.hsm /run/initramfs/memory/system/huronOS/programming/
