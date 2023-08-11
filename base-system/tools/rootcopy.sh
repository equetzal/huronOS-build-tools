#!/bin/bash

#	rootcopy.sh
#	Copies the usrroot files
#   and other folders with a rootlike structure
#   to the specified USB drive
#
#	Copyright (C) 2022, huronOS Project:
#		<http://huronos.org>
#
#	Licensed under the GNU GPL Version 2
#		<http://www.gnu.org/licenses/gpl-2.0.html>
#
#	Authors:
#		Daniel Cerna <cernadaniel@huronos.org>

# Goes to the root of the project
cd ../../
# Obtains the target path
TARGET=$1
shift 1
if [ -z "$1" ]; then
    echo "No path specified, please run [rootcopy.sh <DEST_PATH> [--is-usb]]"
    exit 1
fi
# Allows to specify if the target is a USB drive
if [ -n "$1" ] && [ "$1" = "--is-usb" ]; then
    # If target is a USB drive, then we go to the rootcopy folder
    TARGET="$TARGET/huronOS/rootcopy"
    mkdir -p "$TARGET"
fi
cp -r base-system/usrroot/* "$TARGET"
#cp -r packages/hos-wallpaper/* "$TARGET"
#cp -r packages/hos-software/* "$TARGET"
