#!/bin/bash

#	change-password.sh
#	Script to change the password stored in the core files of a huronOS distribution
#
#	Copyright (C) 2023, huronOS Project:
#		<http://huronos.org>
#
#	Licensed under the GNU GPL Version 2
#		<http://www.gnu.org/licenses/gpl-2.0.html>
#
#	Authors:
#		Daniel Cerna <dcerna@huronos.org>


# Tests if a password was supplied
if [ -z "$1" ]
  then
  	echo "Usage: change-password.sh your-new-password"
  	exit 1
fi

## Test if the script is started by root user. If not, exit
if [ "0$UID" -ne 0 ]; then
	echo "Only root can run $(basename "$0")"; exit 1
fi

# check for mksquashfs with xz compression
if [ "$(mksquashfs 2>&1 | grep "Xdict-size")" = "" ]; then
   echo "mksquashfs not found or doesn't support -comp xz, aborting, no changes made"
   echo "you may consider installing squashfs-tools package"
   exit 1
fi


MAIN_PATH="$(pwd)"
if [ -n "$2" ]; then
  MAIN_PATH="$2"
fi
FILE_NAME="01-core.hsl"
MAIN_FILE="$MAIN_PATH/huronOS/base/$FILE_NAME"

LAB_DIR="/tmp/lab-$$"
LAB_FILE="$LAB_DIR/$FILE_NAME"
LAB_UNSQUASHED="$LAB_DIR/squashfs-root"
NEW_PASSWORD=$1
# Prepares the lab
mkdir "$LAB_DIR"
cd "$LAB_DIR" || exit 1
cp "$MAIN_FILE" "$LAB_FILE"
# Extracts the files
unsquashfs "$MAIN_FILE"
# Sets core files as root -> Updates root password -> "Types" the password twice
echo -e "$NEW_PASSWORD\n$NEW_PASSWORD" | sudo chroot "$LAB_UNSQUASHED" passwd root
# Packages again the core files
mksquashfs "$LAB_UNSQUASHED" "$LAB_FILE" -comp xz -b 1024K -always-use-fragments -noappend
# Removes the original file
rm "$MAIN_FILE"
# Moves the updated core files to the original path
mv "$LAB_FILE" "$MAIN_FILE"
# Exits the lab dir
cd "$MAIN_PATH" || exit 1
# Calculates new checksum
NEW_CHECKSUM=$(sha256sum huronOS/base/$FILE_NAME)
# Replaces old checksum with the new checksum
sed -i "s|.*$FILE_NAME.*|$NEW_CHECKSUM|" checksums
# Clean files
rm -rf "$LAB_DIR"
echo "-----------------------------"
echo "Password successfully updated"
echo "-----------------------------"