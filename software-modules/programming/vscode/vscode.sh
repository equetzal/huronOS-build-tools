#!/bin/bash

#	vscode.sh
#	Script to build the modular software package of Visual Studio Code
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
NAME=vscode
TARGET_DIR="/run/initramfs/memory/system/huronOS/software/programming/"

## Add vscodium keyring
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

## Add repository to deb source list
echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' | tee /etc/apt/sources.list.d/vscodium.list

## Install software
apt update
apt install --yes --no-install-recommends codium
apt autoremove --yes

## Prepare final files
ln -sf /usr/bin/codium /usr/bin/code
ln -sf /usr/bin/codium /usr/bin/vscode
unlink /usr/bin/codium
cp ./codium /usr/bin/codium 
cp ./$NAME.desktop /usr/share/applications/
cp ./$NAME.png /usr/share/pixmaps/vscodium.png
cp ./$NAME.png /usr/share/codium/resources/app/resources/linux/code.png
mkdir -p /opt/codium/contestant/extensions/
mkdir -p /opt/codium/contestant/extensions/ids
chown -R contestant:contestant /opt/codium/contestant
chmod 755 /usr/bin/codium

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
