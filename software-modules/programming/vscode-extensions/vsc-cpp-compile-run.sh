#!/bin/bash

EXTENSION_NAME="vsc-cpp-compile-run"
EXTENSION_FILE="$EXTENSION_NAME.vsix"
EXTENSION_URL="https://github.com/danielpinto8zz6/c-cpp-compile-run/releases/download/v1.0.45/c-cpp-compile-run-1.0.45.vsix"
EXTENSION_FOLDER="$EXTENSION_NAME/extension"
# Downloads extension
curl -o "$EXTENSION_NAME.vsix" -L "$EXTENSION_URL"
# Extracts current extension
mkdir "$EXTENSION_NAME"
unzip -q "$EXTENSION_FILE" -d "$EXTENSION_NAME"

LAB_FOLDER="$EXTENSION_NAME-hsm-lab/"
DESTINATION_FOLDER="$LAB_FOLDER/usr/share/codium/resources/app/extensions/"

# Moves extension to the destination folder
mkdir -p "$DESTINATION_FOLDER"
mv "$EXTENSION_FOLDER" "$DESTINATION_FOLDER/$EXTENSION_NAME"
mksquashfs "$LAB_FOLDER" "$EXTENSION_NAME.hsm" -quiet
rm -r "$LAB_FOLDER" "$EXTENSION_FILE" "$EXTENSION_NAME"

# Moves the output file
mv "$EXTENSION_NAME.hsm" /run/initramfs/memory/system/huronOS/software/programming/
