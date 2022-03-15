#!/bin/bash

#	build-kernel.sh
#	Building AUFS Kernel for huronOS
#	Author: Enya Quetzalli <enya@quetza.ly>

# Run as root
(( EUID != 0 )) && exec sudo -- "$0" "$@"

# Set basic kernel data
set -e
export KERNEL_VERSION=5.10.103
export AUFS_REPOSITORY=aufs5-standalone
export AUFS_BRANCH=origin/aufs5.10.82

# Check if apt is available
if ! command -v apt; then
	echo "apt not found."
	exit
fi

# Download kernel and build tools
source download-kernel.sh

# Compile the kernel
source compile-kernel.sh
