#!/bin/bash

#	compile-kernel.sh
#	Compile AUFS Kernel
#	Author:
#		Enya Quetzalli <equetzal@huronos.org>

pushd linux-$KERNEL_VERSION

## Compile Linux
make clean
make -j 1 bzImage 2>&1 | tee kernel_compilation.log
make -j 1 modules 2>&1 | tee kernel_modules_compilation.log
make headers_install
make modules_install INSTALL_MOD_STRIP=1

## Compile AUFS Module
pushd $AUFS_REPOSITORY
make
make install
make install_headers
popd

## Compile the AUFS Tools
pushd $AUFS_TOOLS_REPOSITORY
make install
make install_ulib
popd

## Save installed kernel for future use
TMP=/ker
NAME=$KERNEL_VERSION-huronos
mkdir -p $TMP/usr/lib/modules
mkdir -p $TMP/usr/include/linux
cp -ar /usr/lib/modules/$NAME $TMP/usr/lib/modules
cp -ar /usr/include/linux/* $TMP/usr/include/linux/
rm -f $TMP/usr/lib/modules/$NAME/{build,source}
mkdir -p $TMP/boot
cp arch/x86/boot/bzImage $TMP/boot/vmlinuz-$NAME
cd $TMP
tar -c * | gzip -f >/$NAME.tar.gz

popd
