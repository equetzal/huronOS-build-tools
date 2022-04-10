#!/bin/bash

#	compile-kernel.sh
#	Compile AUFS Kernel
#	Author: Enya Quetzalli <enya@quetza.ly>
pushd linux-$KERNEL_VERSION

make clean
#make -j $(getconf _NPROCESSORS_ONLN) deb-pkg
make -j $(getconf _NPROCESSORS_ONLN) bzImage 2>&1 | tee kernel_compilation.log
make -j 1 modules 2>&1 | tee kernel_modules_compilation.log

make modules_install INSTALL_MOD_STRIP=1

TMP=/hos-ker
NAME=$KERNEL_VERSION-huronos
mkdir -p $TMP/usr/lib/modules
cp -aR /usr/lib/modules/$NAME $TMP/usr/lib/modules
rm -f $TMP/usr/lib/modules/$NAME/{build,source}
mkdir -p $TMP/boot
cp arch/x86/boot/bzImage $TMP/boot/vmlinuz-$NAME
cd $TMP
tar -c * | gzip -f >/$NAME.tar.gz

popd
