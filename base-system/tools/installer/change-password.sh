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
MAIN_CORE_FILE="$MAIN_PATH/huronOS/base/01-core.hsl"
LAB_CORE_DIR="$MAIN_PATH/lab/01-core"
LAB_CORE_FILE="$MAIN_PATH/lab/01-core.hsl"
NEW_PASSWORD="$1"
mkdir -p "$LAB_CORE_DIR"
# Extracts the core files
sudo unsquashfs -Updatef -d "$LAB_CORE_DIR" "$MAIN_CORE_FILE"
# Sets core files as root -> Updates root password -> "Types" the password twice
echo -e "$NEW_PASSWORD\n$NEW_PASSWORD" | sudo chroot "$LAB_CORE_DIR" passwd root
# Packages again the core files
mksquashfs "$LAB_CORE_DIR" "$LAB_CORE_FILE" -comp xz -b 1024K -always-use-fragments -noappend
# Removes the original file
rm "$MAIN_CORE_FILE"
# Moves the updated core files to the original path
mv "$LAB_CORE_FILE" "$MAIN_CORE_FILE"
# Calculates new checksum
NEW_CHECKSUM=$(sha256sum huronOS/base/01-core.hsl)
# Replaces old checksum with the new checksum
sed -i "s|.*01-core.*|$NEW_CHECKSUM|" checksums
# Clean files
sudo rm -rf lab/
