#!/bin/sh

set -xe
NAME=crow

## Install software
apt update
apt install --yes --no-install-recommends ./crow-translate_2.8.4-focal1_amd64.deb
apt autoremove --yes

## Prepare final files
cp ./$NAME.desktop /usr/share/applications/

## Create packed changes
savechanges /tmp/$NAME.hsm

## Clean package to maintain only relevant files
hsm2dir /tmp/$NAME.hsm
rm -rf /tmp/$NAME.hsm/var
rm -rf /tmp/$NAME.hsm/root
rm -rf /tmp/$NAME.hsm/home
rm -rf /tmp/$NAME.hsm/etc
rm -rf /tmp/$NAME.hsm/usr/share/gnome
rm -rf /tmp/$NAME.hsm/usr/share/icons/hicolor/icon-theme.cache
rm -rf /tmp/$NAME.hsm/usr/share/applications/bamf-2.index
rm -rf /tmp/$NAME.hsm/usr/share/applications/mimeinfo.cache
rm -rf /tmp/$NAME.hsm/usr/share/applications/io.crow*
dir2hsm /tmp/$NAME.hsm

cp /tmp/$NAME.hsm /run/initramfs/memory/data/huronOS/internet/
echo "Finished creating $NAME.hsm!"
