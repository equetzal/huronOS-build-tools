#!/bin/sh

set -xe
NAME=joe

apt update
apt install --yes --no-install-recommends $NAME
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
rm -rf /tmp/$NAME.hsm/etc/alternatives
rm -rf /tmp/$NAME.hsm/usr/share/gnome
rm -rf /tmp/$NAME.hsm/usr/share/applications/bamf-2.index
rm -rf /tmp/$NAME.hsm/usr/share/applications/mimeinfo.cache
rm -rf /tmp/$NAME.hsm/usr/share/applications/jstar.desktop
rm -rf /tmp/$NAME.hsm/usr/share/applications/jpico.desktop
rm -rf /tmp/$NAME.hsm/usr/share/applications/jmacs.desktop
dir2hsm /tmp/$NAME.hsm

cp /tmp/$NAME.hsm /run/initramfs/memory/data/huronOS/programming/
echo "Finished creating $NAME.hsm!"
