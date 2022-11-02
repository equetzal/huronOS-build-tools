#!/bin/bash

#	download-kernel.sh
#	Download Linux Kernel, AUFS patches and AUFS Tools
#
#	Copyright (C) 2022, huronOS Project:
#		<http://huronos.org>
#
#	Licensed under the GNU GPL Version 2
#		<http://www.gnu.org/licenses/gpl-2.0.html>	
#
#	Authors:
#		Enya Quetzalli <equetzal@huronos.org>

cp -ar ./sources.list /etc/apt/sources.list
apt update

# Download Linux kernel
apt install --yes --no-install-recommends $PACKAGES
apt source linux --yes
pushd linux-$KERNEL_VERSION

# Download AUFS standalone code
rm -rf $AUFS_REPOSITORY
git clone https://github.com/sfjro/$AUFS_REPOSITORY
pushd $AUFS_REPOSITORY
git checkout $AUFS_BRANCH
popd

# Download AUFS tools
rm -rf $AUFS_TOOLS_REPOSITORY
git clone https://git.code.sf.net/p/aufs/aufs-util aufs-aufs-util
pushd $AUFS_TOOLS_REPOSITORY
git checkout $AUFS_TOOLS_BRANCH
popd

# Patch the Linux kernel with AUFS support
cp -ar $AUFS_REPOSITORY/Documentation .
cp -ar $AUFS_REPOSITORY/fs .
cp -a $AUFS_REPOSITORY/include/uapi/linux/aufs_type.h include/uapi/linux
patch -p1 < $AUFS_REPOSITORY/aufs5-kbuild.patch
patch -p1 < $AUFS_REPOSITORY/aufs5-base.patch
patch -p1 < $AUFS_REPOSITORY/aufs5-mmap.patch
patch -p1 < $AUFS_REPOSITORY/aufs5-standalone.patch
patch -p1 < $AUFS_REPOSITORY/aufs5-loopback.patch
patch -p1 < $AUFS_REPOSITORY/tmpfs-idr.patch
patch -p1 < $AUFS_REPOSITORY/vfs-ino.patch

# Load huronOS config file
cp ../huronos.config ./.config
# Fill non configured parameters as default
make olddefconfig

popd
