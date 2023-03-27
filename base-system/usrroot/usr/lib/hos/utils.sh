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
# $3 = URL of sha256
safe_download(){
	local FILE_URL FILE_HASH_URL SAVE_PATH TMP TMP_FILE
	FILE_URL="$1"
	SAVE_PATH="$2"
	FILE_HASH_URL="$3"
	TMP="/tmp/safe-download-$$"
	TMP_FILE="$TMP/$(basename "$FILE_URL")"
	TMP_HASH_FILE="$TMP/$(basename "$FILE_HASH_URL")"

	## Try the download into temp
	mkdir -p "$TMP"
	if ! wget --no-cache --tries=3 --timeout=10 "$FILE_URL" -O "$TMP_FILE"; then
		echo "Cannot download the requested url $FILE_URL" 1>&2
		rm -rf "$TMP"
		return 1 # Error
	fi

	if [ ! -z "$FILE_HASH_URL" ]; then
		## If hash cannot be downloaded, then it's not possible to verify file
		if ! wget --no-cache --tries=3 --timeout=10 "$FILE_HASH_URL" -O "$TMP_HASH_FILE"; then
			echo "Cannot download the hash file $FILE_HASH_URL" 1>&2
			rm -rf "$TMP"
			return 1 # Error
		fi

		## If hash does not match, do not save file
		pushd "$TMP"
		if ! sha256sum --status --check "$TMP_HASH_FILE"; then
			echo "Downloaded file does not match it's hash, aborting. $FILE_URL" 1>&2
			popd
			rm -rf "$TMP"
			return 1 # Error
		fi
		popd
	fi

	## Everything seems to be fine, copy file to final path
	cp -f "$TMP_FILE" "$SAVE_PATH"
	rm -rf "$TMP"
	echo "Successfully downloaded file $SAVE_PATH"
	return 0 # Success
}


## Given an URL and it's hash, returns if it should redownload a file or not
# $1 = Saved file path
# $2 = URL of sha256
should_redownload_file(){
	local FILE_PATH FILE_HASH_URL TMP TMP_FILE TMP_HASH_FILE
	FILE_PATH="$1"
	FILE_HASH_URL="$2"
	TMP="/tmp/verify-download-$$"
	TMP_HASH_FILE="$TMP/$(basename "$FILE_HASH_URL")"

	## If file does not exists, then yes, we need to redownload it.
	if [ ! -f "$FILE_PATH" ]; then
		return 0 # Yes, download
	fi

	mkdir -p "$TMP"
	## Local file exists, but we cannot download its hash. Assume current file is not valid
	if ! wget --no-cache --tries=3 --timeout=10 "$FILE_HASH_URL" -O "$TMP_HASH_FILE"; then
		echo "Cannot download the hash file $FILE_HASH_URL" 1>&2
		rm -rf "$TMP"
		return 0 # Yes, download
	fi

	## Copy local file to match hash file name
	TMP_FILE="$TMP/$(cat "$TMP_HASH_FILE" | awk '{ print $2 }' )"
	cp -f "$FILE_PATH" "$TMP_FILE"

	pushd "$TMP"
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