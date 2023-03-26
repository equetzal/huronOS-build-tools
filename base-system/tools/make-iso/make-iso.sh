#!/bin/bash

ISO_DIR=""
ISO_TOOL=""
ISO_OUTPUT=""
readonly ISO_DIR
readonly ISO_TOOL
readonly ISO_OUTPUT

## Move to ISO directory
CURRENT_PATH="$(PWD)"
echo "Moving to $ISO_DIR"
cd "$ISO_DIR" || exit 1 # error

## Create ISO
echo "Generating $ISO_OUTPUT"
"$ISO_TOOL" -o "$ISO_OUTPUT" -v -J -R -D -A "huronOS" -V "huronOS" -no-emul-boot -boot-info-table -boot-load-size 4 -b boot/isolinux.bin -c boot/isolinux.boot .

## Return to original directory
cd "$CURRENT_PATH" || exit 1 # error
echo "Finished! :)"
exit 0 # sucess