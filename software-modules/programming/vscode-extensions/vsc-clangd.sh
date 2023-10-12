#!/bin/bash

#	vsc-cpp-compile-run.sh
#	Script to build the modular software package of Visual Studio Code
#	clangd extension.
#
#	Copyright (C) 2023, huronOS Project:
#		<http://huronos.org>
#
#	Licensed under the GNU GPL Version 2
#		<http://www.gnu.org/licenses/gpl-2.0.html>
#
#	Authors:
#		Daniel Cerna <dcerna@huronos.org>

set -xe

EXTENSION_NAME="vsc-clangd"
EXTENSION_FILE="$EXTENSION_NAME.vsix"
EXTENSION_URL="https://github.com/clangd/vscode-clangd/releases/download/0.1.24/vscode-clangd-0.1.24.vsix"
EXTENSION_FOLDER="$EXTENSION_NAME/extension"
HSM_FILE="$EXTENSION_NAME.hsm"
# Downloads extension
curl -o "$EXTENSION_FILE" -L "$EXTENSION_URL"
# Extracts current extension
mkdir "$EXTENSION_NAME"
unzip -q "$EXTENSION_FILE" -d "$EXTENSION_NAME"
# Prepares lab folder
LAB_FOLDER="$EXTENSION_NAME-hsm-lab/"
DESTINATION_FOLDER="$LAB_FOLDER/usr/share/codium/resources/app/extensions/"
mkdir -p "$DESTINATION_FOLDER"
# Moves extension to the destination folder
mv "$EXTENSION_FOLDER" "$DESTINATION_FOLDER/$EXTENSION_NAME"
# Creates the huronOS module
mksquashfs "$LAB_FOLDER" "$HSM_FILE" -quiet
# Removes any temporary file
rm -r "$LAB_FOLDER" "$EXTENSION_FILE" "$EXTENSION_NAME"
# Moves the module to the final destination
mv "$HSM_FILE" /run/initramfs/memory/system/huronOS/software/programming/
