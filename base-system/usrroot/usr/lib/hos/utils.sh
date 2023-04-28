#!/bin/bash

#	utils.sh
#	General util functions to use on general huronOS scripts
#
#	Copyright (C) 2022, huronOS Project:
#		<http://huronos.org>
#
#	Licensed under the GNU GPL Version 2
#		<http://www.gnu.org/licenses/gpl-2.0.html>
#
#	Authors:
#		Enya Quetzalli <equetzal@huronos.org>

## Download and saves a file given a URL and it's sha256 hash
## asuming that all parameters are provided and URLs are valid
# $1 = URL of image
# $2 = File path to save
# $3 = Sha256 of wallpaper
safe_download() {
	local FILE_URL SAVE_PATH FILE_HASH FILE_NAME TMP TMP_FILE TMP_HASH_FILE
	FILE_URL="$1"
	SAVE_PATH="$2"
	FILE_HASH="$3"
	FILE_NAME=$(basename "$FILE_URL")
	TMP="/tmp/safe-download-$$"
	TMP_FILE="$TMP/$FILE_NAME"
	TMP_HASH_FILE="$TMP/${FILE_NAME}.sha256"

	## Try the download into temp
	mkdir -p "$TMP"
	if ! wget --no-cache --tries=3 --timeout=10 "$FILE_URL" -O "$TMP_FILE"; then
		echo "Cannot download the requested url $FILE_URL" 1>&2
		rm -rf "$TMP"
		return 1 # Error
	fi

	pushd "$TMP"
	## Write hash into hash file
	echo "$FILE_HASH  $FILE_NAME" >"$TMP_HASH_FILE"
	## If hash does not match, do not save file
	pushd "$TMP"
	if ! sha256sum --status --check "$TMP_HASH_FILE"; then
		echo "Downloaded file does not match it's hash, aborting. $FILE_URL" 1>&2
		popd
		rm -rf "$TMP"
		return 1 # Error
	fi
	popd

	## Everything seems to be fine, copy file to final path
	cp -f "$TMP_FILE" "$SAVE_PATH"
	rm -rf "$TMP"
	echo "Successfully downloaded file $SAVE_PATH"
	return 0 # Success
}

## Given a file and it's hash, returns if it should redownload a file or not
# $1 = Saved file path
# $2 = URL of wallpaper
# $3 = Sha256 of wallpaper
should_redownload_file() {
	local FILE_PATH FILE_URL FILE_HASH FILE_NAME TMP TMP_FILE TMP_HASH_FILE
	FILE_PATH="$1"
	FILE_URL="$2"
	FILE_HASH="$3"
	FILE_NAME=$(basename "$FILE_URL")
	## Get the basename of the wallpaper as mentioned in the hash
	TMP="/tmp/verify-download-$$"
	TMP_FILE="$TMP/$FILE_NAME"
	TMP_HASH_FILE="$TMP/${FILE_NAME}.sha256"

	## If file does not exists, then yes, we need to redownload it.
	if [ ! -f "$FILE_PATH" ]; then
		return 0 # Yes, download
	fi

	mkdir -p "$TMP"
	## Copy local file to match hash file name
	cp -f "$FILE_PATH" "$TMP_FILE"

	pushd "$TMP"
	## Write hash into hash file
	echo "$FILE_HASH  $FILE_NAME" >"$TMP_HASH_FILE"
	## If the local file does not match the hash, we need to redownload the file
	if ! sha256sum --status --check "$TMP_HASH_FILE"; then
		echo "Local file does not match remote hash, file is not the same." 1>&2
		popd
		rm -rf "$TMP"
		return 0 # Yes, download
	fi
	popd

	## Hash stills the same, so current file stills valid.
	rm -rf "$TMP"
	return 1 # No download
}
