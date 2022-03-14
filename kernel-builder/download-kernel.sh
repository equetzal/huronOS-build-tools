#!/bin/bash

#	download-kernel.sh
#	Download AUFS Kernel
#	Author: Enya Quetzalli <enya@quetza.ly>

# Download git
if ! command -v git; then
	echo "Installing git"
	apt install --yes --no-install-recommends git
fi

if ! [ -d "$AUFS_REPOSITORY" ]; then
	git clone $AUFS_REPOSITORY_URL
fi

pushd $AUFS_REPOSITORY
	git checkout $AUFS_BRANCH
popd


