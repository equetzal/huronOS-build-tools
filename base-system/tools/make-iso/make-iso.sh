#!/bin/bash

#	make-iso.sh
#	Script to generate the ISO file for huronOS
#
#	Copyright (C) 2022, huronOS Project:
#		<http://huronos.org>
#
#	Licensed under the GNU GPL Version 2
#		<http://www.gnu.org/licenses/gpl-2.0.html>
#
#	Authors:
#		Enya Quetzalli <equetzal@huronos.org>

ISO_DATA=""
ISO_TOOL=""
ISO_OUTPUT=""
CHECKSUMS="./checksums"
EFI_DIR=""
BOOT_DIR=""
HURONOS_DIR=""
readonly ISO_DATA
readonly ISO_TOOL
readonly ISO_OUTPUT
readonly CHECKSUMS
readonly EFI_DIR
readonly BOOT_DIR
readonly HURONOS_DIR

## Move to ISO directory
CURRENT_PATH="$(pwd)"
echo "Moving to $ISO_DATA"
cd "$ISO_DATA" || exit 1 # error

## Calculate checksums
rm -rf "$CHECKSUMS"
FILES_TO_CHECK="$(find "$EFI_DIR" -type f -print) $(find "$BOOT_DIR" -type f -print) $(find "$HURONOS_DIR" -type f -print)"
for FILE in $FILES_TO_CHECK; do
	echo "Calculating checksum: $FILE"
	sha256sum -b "$FILE" >>"$CHECKSUMS"
done
## Delete isolinux.boot and isolinux.bin due to mkisofs recalc
## this binaries acording to ISO 9660 standard. This will make
## checksum to always be different.
sed '/.*isolinux.boot.*/d' -i "$CHECKSUMS"
sed '/.*isolinux.bin.*/d' -i "$CHECKSUMS"

## Create ISO
echo "Generating $ISO_OUTPUT"
"$ISO_TOOL" -o "$ISO_OUTPUT" -v -J -R -D -A "huronOS" -V "huronOS" -no-emul-boot -boot-info-table -boot-load-size 4 -b boot/isolinux.bin -c boot/isolinux.boot .

## Gen ISO Hash
sha256sum "$ISO_OUTPUT" >>"$ISO_OUTPUT.sha256"
md5sum "$ISO_OUTPUT" >>"$ISO_OUTPUT.md5"

## Return to original directory
cd "$CURRENT_PATH" || exit 1 # error
echo "Finished! :) -> $ISO_OUTPUT"
exit 0 # sucess
