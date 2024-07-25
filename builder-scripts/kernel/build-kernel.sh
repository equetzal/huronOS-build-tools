#!/bin/bash

#	build-kernel.sh
#	Scripts to automate the build of the huronOS kernel
#	which required to support AUFS and AUFS-tools, and
#	do also have a custom configuration file according to
#	the hardware targeted by huronOS.
#	Compile huronOS Kernel
#
#	Copyright (C) 2022, huronOS Project:
#		<http://huronos.org>
#
#	Licensed under the GNU GPL Version 2
#		<http://www.gnu.org/licenses/gpl-2.0.html>
#
#	Authors:
#		Enya Quetzalli <equetzal@huronos.org>

# Set basic kernel data
set -xe
export HTOOLS_KERNEL_DIR="$(pwd)"
export KERNEL_VERSION=6.1.31
export AUFS_REPOSITORY=aufs-standalone
export AUFS_BRANCH=aufs6.1
export AUFS_TOOLS_REPOSITORY=aufs-util
export AUFS_TOOLS_BRANCH=aufs6.0
export PACKAGES=""
# Get the dependencies and replace every new line with a space
mapfile -t PACKAGES <dependencies.txt

download_kernel() {
	cp -ar $HTOOLS_KERNEL_DIR/sources.list /etc/apt/sources.list
	apt update

	# Preinstall all the required software to compile the kernel
	apt install --yes --no-install-recommends "${PACKAGES[@]}"

	# Download Linux kernel, AUFS standalone patches and AUFS tools
	git clone --depth 1 --branch v$KERNEL_VERSION https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git || true
	git clone --depth 1 --branch $AUFS_BRANCH https://github.com/sfjro/$AUFS_REPOSITORY || true
	git clone --depth 1 --branch $AUFS_TOOLS_BRANCH https://git.code.sf.net/p/aufs/$AUFS_TOOLS_REPOSITORY || true
}

patch_kernel() {
	# Patch the Linux kernel AUFS standalone following README instructions
	pushd linux
	cp -ar ../$AUFS_REPOSITORY/Documentation .
	cp -ar ../$AUFS_REPOSITORY/fs .
	cp -a ../$AUFS_REPOSITORY/include/uapi/linux/aufs_type.h include/uapi/linux
	patch -p1 <../$AUFS_REPOSITORY/aufs6-kbuild.patch
	patch -p1 <../$AUFS_REPOSITORY/aufs6-base.patch
	patch -p1 <../$AUFS_REPOSITORY/aufs6-mmap.patch
	patch -p1 <../$AUFS_REPOSITORY/aufs6-standalone.patch
	patch -p1 <../$AUFS_REPOSITORY/aufs6-loopback.patch
	patch -p1 <../$AUFS_REPOSITORY/vfs-ino.patch
	patch -p1 <../$AUFS_REPOSITORY/tmpfs-idr.patch
	popd
}

configure_kernel() {
	pushd linux

	# Load huronOS config file
	cp $HTOOLS_KERNEL_DIR/huronos.config ./.config
	# Fill non configured parameters as default
	make olddefconfig

	popd
}

compile_kernel() {
	set -o pipefail

	## Compile Linux
	pushd linux
	#make clean  ## Uncomment if facing hard to solve compile errors, keep commented to resume compilation
	make -j 1 bzImage 2>&1 | tee ../kernel_compilation.log
	make -j 1 modules 2>&1 | tee ../kernel_modules_compilation.log
	make headers_install
	make modules_install INSTALL_MOD_STRIP=1
	popd

	## Compile AUFS Module
	pushd $AUFS_REPOSITORY
	sed -i "s;KDIR = .*; KDIR = /lib/modules/$KERNEL_VERSION-huronos+/build;1" ./Makefile
	make
	make install
	make install_headers
	cp usr/include/linux/aufs_type.h /usr/include/linux/
	popd

	## Compile the AUFS Tools
	pushd $AUFS_TOOLS_REPOSITORY
	mkdir -p ./fakeroot
	make install
	make install DESTDIR=./fakeroot
	mkdir -p ./fakeroot/usr/sbin
	mv ./fakeroot/sbin/* ./fakeroot/usr/sbin
	rm -rf ./fakeroot/sbin
	#make install_ulib
	popd

	set +o pipefail
}

save_kernel() {
	## Save installed kernel for future use
	TMP=/tmp/kernel-save-$$
	NAME=$KERNEL_VERSION-huronos+
	mkdir -p $TMP/usr/lib/modules
	mkdir -p $TMP/usr/include/linux
	cp -ar /usr/lib/modules/$NAME $TMP/usr/lib/modules
	cp -ar /usr/include/linux/* $TMP/usr/include/linux/
	cp -ar "$AUFS_TOOLS_REPOSITORY/fakeroot/"* "$TMP/"
	rm -f $TMP/usr/lib/modules/$NAME/{build,source}
	mkdir -p $TMP/boot
	cp linux/arch/x86/boot/bzImage $TMP/boot/vmlinuz-$NAME
	cd $TMP
	tar -c * | gzip -f >$HTOOLS_KERNEL_DIR/kernel-stuff/$NAME.tar.gz
	echo "Your compiled kernel has been saved on $HTOOLS_KERNEL_DIR/kernel-stuff/$NAME.tar.gz"
}

# $1 = Compressed .taz.gz kernel image
restore_kernel() {
	## Restore a previusly saved kernel into the current system
	local KERNEL_LAB KERNEL_UNTAR_DIR KERNEL_SOURCE_TAR_FILE KERNEL_TAR_FILE
	KERNEL_LAB="/tmp/huronOS-kernel-$$"
	KERNEL_UNTAR_DIR="$KERNEL_LAB/data"
	KERNEL_SOURCE_TAR_FILE="$(realpath "$1")"
	KERNEL_TAR_FILE="$KERNEL_LAB/kernel.tar.gz"

	if [ "$1" = "" ]; then
		printf '%s\n%s' "No TAR file, please run:" "build-kernel.sh [--build | --clean-kernel | --clean-packages | --restore-kernel TAR_FILE]"
	fi

	mkdir -p "$KERNEL_LAB"
	mkdir -p "$KERNEL_UNTAR_DIR"
	cp "$KERNEL_SOURCE_TAR_FILE" "$KERNEL_TAR_FILE"
	tar -xf "$KERNEL_TAR_FILE" -C "$KERNEL_UNTAR_DIR"
	cp -arf $KERNEL_UNTAR_DIR/* /

	KERNEL_NAME="$(ls "$KERNEL_UNTAR_DIR/boot" | sed 's:vmlinuz-::g')"
	update-initramfs -u -k "$KERNEL_NAME" -v
	update-grub2
	rm -rf "$KERNEL_LAB"

	echo "Done!, Please reboot your computer using the advanced boot with kernel version -> $KERNEL_VERSION"
}

clean_other_kernels() {
	for KERNEL_PACKAGE in $(dpkg --list | grep -Ei 'linux-image|linux-headers|linux-modules' | awk '{ print $2 }'); do
		yes | apt purge "$KERNEL_PACKAGE"
	done

	apt autoremove --purge --yes
	apt clean --yes
	update-grub2
}

delete_packages() {
	apt remove --yes $PACKAGES
	apt autoremove --purge --yes
	apt clean --yes
}

main() {
	# Run as root
	((EUID != 0)) && exec sudo -- "$0" "$@"

	# Check if apt is available
	if ! command -v apt; then
		echo "apt not found."
		exit
	fi

	if [ "$1" = "--build" ]; then
		mkdir -p ./kernel-stuff/
		pushd ./kernel-stuff/
		download_kernel
		patch_kernel
		configure_kernel
		compile_kernel
		save_kernel
		popd
	elif [ "$1" = "--clean-kernel" ]; then
		clean_other_kernels
	elif [ "$1" = "--clean-packages" ]; then
		delete_packages
	elif [ "$1" = "--restore-kernel" ]; then
		restore_kernel "$2"
	else
		printf '%s\n%s' "No option selected, run:" "build-kernel.sh [--build | --clean-kernel | --clean-packages | --restore-kernel TAR_FILE]"
	fi
}

main "$@"
