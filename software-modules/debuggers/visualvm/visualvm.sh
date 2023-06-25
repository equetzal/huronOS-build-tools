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
MAIN_PATH="$(dirname "$(readlink -f "$0")")"

apt update

## Patch visualvm so it is not linked to the javasdk
## allowing only the relevant visualvm files to be preserved
cd /tmp
apt download visualvm
mkdir tmp-visualvm
dpkg-deb -R visualvm_2.1.5-1_all.deb tmp-visualvm
sed -i 's/default-jdk (>= 2:1.11) | java11-sdk, //' tmp-visualvm/DEBIAN/control
dpkg-deb -b tmp-visualvm visualvm-patched.deb

## Install java so it doesn't autoinstall
apt install  --yes --no-install-recommends openjdk-17-jdk default-jdk

## Install software
apt install --yes --no-install-recommends $NAME

## Remove java and it's dependencies
## effectively keeping visualvm and its files
apt remove  --yes --autoremove openjdk-17-jdk default-jdk

## Prepare final files
cp "$MAIN_PATH/$NAME.desktop" /usr/share/applications/

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
