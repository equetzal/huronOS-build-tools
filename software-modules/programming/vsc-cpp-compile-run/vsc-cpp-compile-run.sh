#!/bin/bash

#	vsc-cpp-compile-run.sh
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
NAME=vsc-cpp-compile-run
TARGET_DIR="/run/initramfs/memory/system/huronOS/software/programming/"
EXTENSIONS_DIR="/opt/codium/contestant/extensions"
EXTENSION_INSTALLER="/tmp/$NAME.vsix"
EXTENSION_URL="https://github.com/danielpinto8zz6/c-cpp-compile-run/releases/download/v1.0.45/c-cpp-compile-run-1.0.45.vsix"

## Install extension
wget "$EXTENSION_URL" -O "$EXTENSION_INSTALLER"
hmm -u --activate "/run/initramfs/memory/system/huronOS/software/programming/vscode.hsm"
/usr/share/codium/bin/codium --install-extension "$EXTENSION_INSTALLER" --extensions-dir "$EXTENSIONS_DIR" --no-sandbox --user-data-dir /tmp/

## Set files and permissions
mkdir -p "$EXTENSIONS_DIR/ids/"
chown -R contestant:contestant "$EXTENSIONS_DIR"
chmod -R 755 "$EXTENSIONS_DIR"
mv -f "$EXTENSIONS_DIR/extensions.json" "$EXTENSIONS_DIR/ids/$NAME.json"
sed -i -e '1s/^.//' -e '$s/.$//' "$EXTENSIONS_DIR/ids/$NAME.json"

## Clean package to maintain only relevant files
mkdir -p /tmp/$NAME.hsm/opt
cp -arf /opt/codium /tmp/$NAME.hsm/opt/

## Make module
find /tmp/$NAME.hsm/
dir2hsm /tmp/$NAME.hsm

## Save module
cp /tmp/$NAME.hsm "$TARGET_DIR/$NAME.hsm"
echo "Finished creating $NAME.hsm!"
