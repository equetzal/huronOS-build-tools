#!/bin/bash

#	firefox.sh
#	Script to build the modular software package of Firefox
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
NAME=firefox
TARGET_DIR="/run/initramfs/memory/system/huronOS/software/internet/"

## Install software
apt update
apt install --yes --no-install-recommends firefox-esr
apt autoremove --yes

## Prepare final files
cp ./$NAME.desktop /usr/share/applications/

## Prepare bookmarks extension
# The middleman between huron and the browser
curl -o /usr/bin/bookmarks-fetcher.py https://raw.githubusercontent.com/huronOS/bookmark-bridge/development/app/bookmarks-fetcher.py
curl -o /usr/bin/current-bookmarks https://raw.githubusercontent.com/huronOS/bookmark-bridge/development/app/current-bookmarks
chmod +x /usr/bin/bookmarks-fetcher.py
chmod +x /usr/bin/current-bookmarks

# The extension's native host
FF_NATIVE_HOST="/usr/lib/mozilla/native-messaging-hosts"
mkdir -p $FF_NATIVE_HOST
curl -o "$FF_NATIVE_HOST/bookmarks_fetcher.json" https://raw.githubusercontent.com/huronOS/bookmark-bridge/development/firefox-native-host.json

# The extension
FF_EXT_PATH="/usr/lib/firefox-esr/distribution/extensions"
mkdir -p $FF_EXT_PATH
curl -o "$FF_EXT_PATH/bookmarks@huronos.org.xpi" -L https://github.com/huronOS/bookmark-bridge/releases/latest/download/bookmark-bridge.xpi

## Create packed changes
savechanges /tmp/$NAME.hsm

## Clean package to maintain only relevant files
hsm2dir /tmp/$NAME.hsm
rm -rf /tmp/$NAME.hsm/var
rm -rf /tmp/$NAME.hsm/root
rm -rf /tmp/$NAME.hsm/home
rm -rf /tmp/$NAME.hsm/etc/hmm
rm -rf /tmp/$NAME.hsm/etc/hsync
rm -rf /tmp/$NAME.hsm/etc/timezone
rm -rf /tmp/$NAME.hsm/etc/localtime
rm -rf /tmp/$NAME.hsm/etc/ld.so.cache
rm -rf /tmp/$NAME.hsm/usr/share/mime
rm -rf /tmp/$NAME.hsm/usr/share/gnome
rm -rf /tmp/$NAME.hsm/usr/share/icons
rm -rf /tmp/$NAME.hsm/usr/share/pixmaps
rm -rf /tmp/$NAME.hsm/usr/share/mime-info
rm -rf /tmp/$NAME.hsm/usr/share/backgrounds
rm -rf /tmp/$NAME.hsm/usr/share/applications/bamf-2.index
rm -rf /tmp/$NAME.hsm/usr/share/applications/mimeinfo.cache
rm -rf /tmp/$NAME.hsm/usr/share/applications/firefox-esr.desktop
dir2hsm /tmp/$NAME.hsm

cp /tmp/$NAME.hsm "$TARGET_DIR"
echo "Finished creating $NAME.hsm!"
