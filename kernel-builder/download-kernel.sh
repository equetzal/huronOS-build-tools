#!/bin/bash

#	download-kernel.sh
#	Download AUFS Kernel
#	Author: Enya Quetzalli <equetzal@huronos.org>

cp -aR ./sources.list /etc/apt/sources.list
apt update

# Download Linux kernel
apt install --yes --no-install-recommends $PACKAGES
apt source linux --yes
pushd linux-$KERNEL_VERSION

# Download AUFS standalone code
rm -Rf $AUFS_REPOSITORY
git clone https://github.com/sfjro/$AUFS_REPOSITORY
pushd $AUFS_REPOSITORY
git checkout $AUFS_BRANCH
popd

# Patch the Linux kernel with AUFS support
cp -aR $AUFS_REPOSITORY/fs .
cp -a $AUFS_REPOSITORY/include/uapi/linux/aufs_type.h include/uapi/linux
patch -p1 < $AUFS_REPOSITORY/aufs5-base.patch
patch -p1 < $AUFS_REPOSITORY/aufs5-kbuild.patch
patch -p1 < $AUFS_REPOSITORY/aufs5-loopback.patch
patch -p1 < $AUFS_REPOSITORY/aufs5-mmap.patch
patch -p1 < $AUFS_REPOSITORY/aufs5-standalone.patch
patch -p1 < $AUFS_REPOSITORY/tmpfs-idr.patch
patch -p1 < $AUFS_REPOSITORY/vfs-ino.patch

# Load huronOS config file
cp ../huronos.config ./.config
# Fill non configured parameters as default
make olddefconfig

popd
