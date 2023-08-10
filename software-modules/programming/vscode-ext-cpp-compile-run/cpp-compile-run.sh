#!/bin/bash

#	cpp-compile-run.sh
#	Script to build the modular software package of Visual Studio Code
#	cpp-compile-run extension. It purges the unnecessary files on the FS
#	to allow AUFS add/del operations on the fly.
#
#	Copyright (C) 2023, huronOS Project:
#		<http://huronos.org>
#
#	Licensed under the GNU GPL Version 2
#		<http://www.gnu.org/licenses/gpl-2.0.html>
#
#	Authors:
#		Enya Quetzalli <equetzal@huronos.org>

set -xe
NAME=vscode-ext-cpptools
TARGET_DIR="/run/initramfs/memory/system/huronOS/software/programming/"

## Get extension
EXTENSION="/tmp/$NAME.vsix"
wget "https://github.com/danielpinto8zz6/c-cpp-compile-run/releases/download/v1.0.15/c-cpp-compile-run-1.0.15.vsix" -O "$EXTENSION"

## Enable vscode
hmm -u --activate "/run/initramfs/memory/system/huronOS/software/programming/vscode.hsm"
codium --install-extension "$EXTENSION"

## Create packed changes
savechanges /tmp/$NAME.hsm

## Clean package to maintain only relevant files
hsm2dir /tmp/$NAME.hsm
rm -rf /tmp/$NAME.hsm/var
rm -rf /tmp/$NAME.hsm/etc
rm -rf /tmp/$NAME.hsm/root
rm -rf /tmp/$NAME.hsm/home
rm -rf /tmp/$NAME.hsm/usr/sbin
rm -rf /tmp/$NAME.hsm/usr/share/gnome
rm -rf /tmp/$NAME.hsm/usr/share/mime
rm -rf /tmp/$NAME.hsm/usr/share/icons/hicolor/icon-theme.cache
rm -rf /tmp/$NAME.hsm/usr/share/applications/bamf-2.index
rm -rf /tmp/$NAME.hsm/usr/share/applications/mimeinfo.cache
rm -rf /tmp/$NAME.hsm/usr/share/applications/code.desktop
rm -rf /tmp/$NAME.hsm/usr/share/applications/code-url-handler.desktop
rm -rf /tmp/$NAME.hsm//etc/apt/sources.list
find /tmp/$NAME.hsm/
dir2hsm /tmp/$NAME.hsm

cp /tmp/$NAME.hsm "$TARGET_DIR/vscode.hsm"
echo "Finished creating $NAME.hsm!"
