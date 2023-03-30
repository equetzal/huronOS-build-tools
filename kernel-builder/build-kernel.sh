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
set -e
export HTOOLS_KERNEL_DIR="$(pwd)"
export KERNEL_VERSION=6.1.18
export AUFS_REPOSITORY=aufs-standalone
export AUFS_BRANCH=aufs6.1
export AUFS_TOOLS_REPOSITORY=aufs-util
export AUFS_TOOLS_BRANCH=aufs6.0
export PACKAGES="asciidoctor autoconf automake autopoint autotools-dev bc binutils binutils-common binutils-x86-64-linux-gnu bison bsdextrautils build-essential bzip2 ca-certificates cpp cpp-10 debhelper dh-autoreconf dh-exec dh-python dh-strip-nondeterminism diffstat docutils-common dpkg-dev dvipng dwarves dwz ed file flex fontconfig fontconfig-config fonts-dejavu-core fonts-font-awesome fonts-lato fonts-lmodern fonts-urw-base35 g++ g++-10 gcc gcc-10 gcc-10-multilib gcc-multilib gettext ghostscript git graphviz groff-base intltool-debian kernel-wedge lib32asan6 lib32atomic1 lib32gcc-10-dev lib32gcc-s1 lib32gomp1 lib32itm1 lib32quadmath0 lib32stdc++6 lib32ubsan1 libann0 libapache-pom-java libarchive-zip-perl libasan6 libatomic1 libaudit-dev libavahi-client3 libavahi-common-data libavahi-common3 libbabeltrace-dev libbabeltrace1 libbinutils libblkid-dev libc-dev-bin libc6-dev libc6-dev-i386 libc6-dev-x32 libc6-i386 libc6-x32 libcairo2 libcap-dev libcap-ng-dev libcc1-0 libcdt5 libcgraph6 libcommons-logging-java libcommons-parent-java libcrypt-dev libctf-nobfd0 libctf0 libcups2 libdatrie1 libdbus-1-3 libdebhelper-perl libdeflate0 libdpkg-perl libdw-dev libdw1 libelf-dev libexpat1-dev libffi-dev libfile-stripnondeterminism-perl libfontbox-java libfontconfig1 libfribidi0 libgcc-10-dev libgd3 libglib2.0-0 libglib2.0-bin libglib2.0-data libglib2.0-dev libglib2.0-dev-bin libgomp1 libgraphite2-3 libgs9 libgs9-common libgts-0.7-5 libgvc6 libgvpr2 libharfbuzz0b libiberty-dev libice6 libicu67 libidn11 libijs-0.35 libisl23 libitm1 libjbig0 libjbig2dec0 libjpeg62-turbo libjs-jquery libjs-sphinxdoc libjs-underscore libkpathsea6 liblab-gamut1 liblcms2-2 liblsan0 libltdl7 liblzma-dev libmagic-mgc libmagic1 libmount-dev libmpc3 libmpdec3 libmpfr6 libncurses5-dev libncursesw5-dev libnewt-dev libnsl-dev libnuma-dev libnuma1 libopencsd-dev libopencsd0 libopenjp2-7 libpango-1.0-0 libpangocairo-1.0-0 libpangoft2-1.0-0 libpaper-utils libpaper1 libpathplan4 libpci-dev libpcre16-3 libpcre2-16-0 libpcre2-32-0 libpcre2-dev libpcre2-posix2 libpcre3-dev libpcre32-3 libpcrecpp0v5 libpdfbox-java libperl-dev libpipeline1 libpixman-1-0 libpng-dev libptexenc1 libpython3-dev libpython3-stdlib libpython3.9 libpython3.9-dev libpython3.9-minimal libpython3.9-stdlib libquadmath0 libruby2.7 libselinux1-dev libsepol1-dev libsigsegv2 libslang2-dev libsm6 libsqlite3-0 libssl-dev libstdc++-10-dev libsub-override-perl libsynctex2 libteckit0 libtexlua53 libtexluajit2 libthai-data libthai0 libtiff5 libtirpc-dev libtool libtsan0 libubsan1 libuchardet0 libudev-dev libunwind-dev libunwind8 libwebp6 libwrap0 libwrap0-dev libx11-6 libx11-data libx32asan6 libx32atomic1 libx32gcc-10-dev libx32gcc-s1 libx32gomp1 libx32itm1 libx32quadmath0 libx32stdc++6 libx32ubsan1 libxau6 libxaw7 libxcb-render0 libxcb-shm0 libxcb1 libxdmcp6 libxext6 libxi6 libxml2 libxmu6 libxpm4 libxrender1 libxt6 libyaml-0-2 libzzip-0-13 linux-libc-dev lz4 m4 make man-db media-types openssl patch patchutils pkg-config po-debconf poppler-data preview-latex-style python-babel-localedata python3 python3-alabaster python3-babel python3-certifi python3-chardet python3-dev python3-distutils python3-docutils python3-idna python3-imagesize python3-jinja2 python3-lib2to3 python3-markupsafe python3-minimal python3-packaging python3-pkg-resources python3-pygments python3-pyparsing python3-requests python3-roman python3-six python3-snowballstemmer python3-sphinx python3-sphinx-rtd-theme python3-tz python3-urllib3 python3.9 python3.9-dev python3.9-minimal quilt rake rsync ruby ruby-asciidoctor ruby-minitest ruby-net-telnet ruby-power-assert ruby-rubygems ruby-test-unit ruby-xmlrpc ruby2.7 rubygems-integration sgml-base sphinx-common sphinx-rtd-theme-common t1utils tex-common texlive-base texlive-binaries texlive-latex-base texlive-latex-extra texlive-latex-recommended texlive-pictures uuid-dev x11-common xdg-utils xml-core xz-utils zlib1g-dev"

download_kernel(){
	cp -ar $HTOOLS_KERNEL_DIR/sources.list /etc/apt/sources.list
	apt update

	# Preinstall all the required software to compile the kernel
	apt install --yes --no-install-recommends $PACKAGES

	# Download Linux kernel, AUFS standalone patches and AUFS tools
	git clone --depth 1 --branch v$KERNEL_VERSION https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git || true
	git clone --depth 1 --branch $AUFS_BRANCH https://github.com/sfjro/$AUFS_REPOSITORY || true
	git clone --depth 1 --branch $AUFS_TOOLS_BRANCH https://git.code.sf.net/p/aufs/$AUFS_TOOLS_REPOSITORY || true
}

patch_kernel(){
	# Patch the Linux kernel AUFS standalone following README instructions
	pushd linux
	cp -ar ../$AUFS_REPOSITORY/Documentation .
	cp -ar ../$AUFS_REPOSITORY/fs .
	cp -a ../$AUFS_REPOSITORY/include/uapi/linux/aufs_type.h include/uapi/linux
	patch -p1 < ../$AUFS_REPOSITORY/aufs6-kbuild.patch
	patch -p1 < ../$AUFS_REPOSITORY/aufs6-base.patch
	patch -p1 < ../$AUFS_REPOSITORY/aufs6-mmap.patch
	patch -p1 < ../$AUFS_REPOSITORY/aufs6-standalone.patch
	patch -p1 < ../$AUFS_REPOSITORY/aufs6-loopback.patch
	patch -p1 < ../$AUFS_REPOSITORY/vfs-ino.patch
	patch -p1 < ../$AUFS_REPOSITORY/tmpfs-idr.patch
	popd
}

configure_kernel(){
	pushd linux

	# Load huronOS config file
	cp $HTOOLS_KERNEL_DIR/huronos.config ./.config
	# Fill non configured parameters as default
	make olddefconfig

	popd
}

compile_kernel(){
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

save_kernel(){
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
restore_kernel(){
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

clean_other_kernels(){
	for KERNEL_PACKAGE in $(dpkg --list | grep -Ei 'linux-image|linux-headers|linux-modules' | awk '{ print $2 }'); do
		yes | apt purge "$KERNEL_PACKAGE"
	done

	apt autoremove --purge --yes
	apt clean --yes
	update-grub2
}

delete_packages(){
	apt remove --yes $PACKAGES
	apt autoremove --purge --yes
	apt clean --yes
}

main(){
	# Run as root
	(( EUID != 0 )) && exec sudo -- "$0" "$@"

	# Check if apt is available
	if ! command -v apt; then
		echo "apt not found."
		exit
	fi

	mkdir -p ./kernel-stuff/
	pushd ./kernel-stuff/

	if [ "$1" = "--build" ]; then
		download_kernel
		patch_kernel
		configure_kernel
		compile_kernel
		save_kernel
	elif [ "$1" = "--clean-kernel" ]; then
		clean_other_kernels
	elif [ "$1" = "--clean-packages" ]; then
		delete_packages
	elif [ "$1" = "--restore-kernel" ]; then
		restore_kernel "$2"
	else
		printf '%s\n%s' "No option selected, run:" "build-kernel.sh [--build | --clean-kernel | --clean-packages | --restore-kernel TAR_FILE]"
	fi

	popd
}

main "$@"
