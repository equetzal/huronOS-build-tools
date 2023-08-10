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
TARGET_DIR="/run/initramfs/memory/system/huronOS/software/programming/"

## Prepare final files
#cp ./$NAME.desktop /usr/share/applications/

## Install software
ECLIPSE_TAR="eclipse.tar.gz"
wget -O "/tmp/$ECLIPSE_TAR" http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/2021-09/R/eclipse-java-2021-09-R-linux-gtk-x86_64.tar.gz
pushd /tmp/
tar zxf "$ECLIPSE_TAR" -C /opt
rm /tmp/eclipse.tar.gz
wget -O /usr/share/pixmaps/eclipse.png "https://icon-icons.com/downloadimage.php?id=94656&root=1381/PNG/64/&file=eclipse_94656.png"
cat - <<EOM >/usr/share/applications/eclipse.desktop
[Desktop Entry]
Name=Eclipse
Exec=/opt/eclipse/eclipse
Type=Application
Icon=eclipse
EOM
# cd eclipse-installer/
# su contestant -c "echo \$! && ./eclipse-inst"
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

cp /tmp/$NAME.hsm "$TARGET_DIR"
echo "Finished creating $NAME.hsm!"
