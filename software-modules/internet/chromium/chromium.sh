#!/bin/bash

#	chromium.sh
#	Script to build the modular software package of Chromium
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
NAME=chromium
TARGET_DIR="/run/initramfs/memory/system/huronOS/software/internet/"

## Install software
apt update
apt install --yes --no-install-recommends $NAME python-is-python3
apt autoremove --yes

## Prepare final files
cp ./$NAME.desktop /usr/share/applications/

## Prepare bookmarks extension
# The extension
curl -o /usr/share/bookmark-bridge.crx -L https://github.com/huronOS/bookmark-bridge/releases/latest/download/bookmark-bridge.crx

# The extension loader
CHROMIUM_EXT_LOADER_PATH="/usr/share/chromium/extensions"
mkdir -p $CHROMIUM_EXT_LOADER_PATH
curl -o "$CHROMIUM_EXT_LOADER_PATH/cbfajpicdmpnnoijdmhdomaailmdaiim.json" https://raw.githubusercontent.com/huronOS/bookmark-bridge/development/chrome-extension-loader.json

# The extension's native host
CHROMIUM_NATIVE_HOST="/etc/chromium/native-messaging-hosts"
mkdir -p $CHROMIUM_NATIVE_HOST
curl -o "$CHROMIUM_NATIVE_HOST/bookmarks_fetcher.json" https://raw.githubusercontent.com/huronOS/bookmark-bridge/development/chrome-native-host.json

# The middleman between huron and the browser
curl -o /usr/bin/bookmarks-fetcher.py https://raw.githubusercontent.com/huronOS/bookmark-bridge/development/app/bookmarks-fetcher.py
curl -o /usr/bin/current-bookmarks https://raw.githubusercontent.com/huronOS/bookmark-bridge/development/app/current-bookmarks
chmod +x /usr/bin/bookmarks-fetcher.py
chmod +x /usr/bin/current-bookmarks

## Create packed changes
savechanges /tmp/$NAME.hsm

## Clean package to maintain only relevant files
hsm2dir /tmp/$NAME.hsm
rm -rf /tmp/$NAME.hsm/var
rm -rf /tmp/$NAME.hsm/root
rm -rf /tmp/$NAME.hsm/home
rm -rf /tmp/$NAME.hsm/etc/ld.so.cache
rm -rf /tmp/$NAME.hsm/usr/share/gnome
rm -rf /tmp/$NAME.hsm/usr/share/icons
rm -rf /tmp/$NAME.hsm/usr/share/chromium/initial_bookmarks.html
rm -rf /tmp/$NAME.hsm/usr/share/applications/bamf-2.index
rm -rf /tmp/$NAME.hsm/usr/share/applications/mimeinfo.cache
dir2hsm /tmp/$NAME.hsm

cp /tmp/$NAME.hsm "$TARGET_DIR"
echo "Finished creating $NAME.hsm!"
