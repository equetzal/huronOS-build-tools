#!/bin/bash

#	build-kernel.sh
#	Building AUFS Kernel for huronOS
#	Author: Enya Quetzalli <enya@quetza.ly>

# Run as root
(( EUID != 0 )) && exec sudo -- "$0" "$@"

# Set basic kernel data
set -e
export KERNEL_VERSION=5.10
export AUFS_REPOSITORY=aufs5-linux
export AUFS_REPOSITORY_URL=https://github.com/sfjro/aufs5-linux.git
export AUFS_BRANCH=aufs5.10

# Check if apt is available
if ! command -v apt; then
	echo "apt not found."
	exit
fi

# Download repo
source download-kernel.sh

# Compile the kernel
source compile-kernel.sh
