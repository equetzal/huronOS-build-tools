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

set -e

# Tests if a password was supplied
if [ -z "$1" ]; then
  echo "Usage: change-password.sh your-new-password"
  exit 1
fi

## Test if the script is started by root user. If not, exit
if [ "0$UID" -ne 0 ]; then
  echo "Only root can run $(basename "$0")"
  exit 1
fi

# check for mksquashfs with xz compression
if [ "$(mksquashfs 2>&1 | grep "Xdict-size")" = "" ]; then
  echo "mksquashfs not found or doesn't support -comp xz, aborting, no changes made"
  echo "you may consider installing squashfs-tools package"
  exit 1
fi

# Get the absolute path of the directory where this script is located
# so no matter where this script is executed (at least manually) it always works as expected.
# This is because the main path is one directory above of this file location (utils/..)
# so the main file could be correctly located.
MAIN_PATH="$(dirname "$(readlink -f "$0")")/.."
if [ -n "$2" ]; then
  MAIN_PATH="$2"
fi
FILE_NAME="05-custom.hsl"
MAIN_FILE="$MAIN_PATH/huronOS/base/$FILE_NAME"

LAB_DIR="/tmp/lab-$$"
LAB_FILE="$LAB_DIR/$FILE_NAME"
LAB_UNSQUASHED="$LAB_DIR/squashfs-root"
SHADOW_FILE="$LAB_UNSQUASHED/etc/shadow"
NEW_PASSWORD=$1
SALT="\$6\$saltsalt\$"
# Prepares the lab
mkdir "$LAB_DIR"
cd "$LAB_DIR" || exit 1
cp "$MAIN_FILE" "$LAB_FILE"
# Extracts the files
unsquashfs "$MAIN_FILE"
# Generate the encrypted password
ENCRYPTED_PASSWORD=$(perl -e "print crypt('$NEW_PASSWORD', '$SALT')")
echo "New password $NEW_PASSWORD"
# Replace the password in the shadow file
sed -i "s|^\(root:\)\(\$[^:]*:\)|\1$ENCRYPTED_PASSWORD:|" "$SHADOW_FILE"
# Ensure root is the owner of the shadow file
chown root "$SHADOW_FILE"
# Ensure propper permissions on the shadow file
chmod 640 "$SHADOW_FILE"
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
echo "----------------------------------------------"
echo "Password successfully updated to $NEW_PASSWORD"
echo "----------------------------------------------"
