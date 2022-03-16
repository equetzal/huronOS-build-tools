#!/bin/bash

#	compile-kernel.sh
#	Compile AUFS Kernel
#	Author: Enya Quetzalli <enya@quetza.ly>
pushd linux-$KERNEL_VERSION

make clean
#make -j $(getconf _NPROCESSORS_ONLN) deb-pkg LOCALVERSION=-huronos
make -j $(getconf _NPROCESSORS_ONLN) bzImage LOCALVERSION=-huronos
make -j $(getconf _NPROCESSORS_ONLN) modules LOCALVERSION=-huronos

make modules_install INSTALL_MOD_STRIP=1

TMP=/hos-ker
mkdir -p $TMP/usr/lib/modules
cp -aR /usr/lib/modules/$KERNEL_VERSION $TMP/usr/lib/modules
rm -f $TMP/usr/lib/modules/$KERNEL_VERSION/{build,source}
mkdir -p $TMP/boot
cp arch/x86/boot/bzImage $TMP/boot/vmlinuz-$KERNEL_VERSION
cd $TMP
tar -c * | gzip -f >/$KERNEL_VERSION-huronos.tar.gz

popd
