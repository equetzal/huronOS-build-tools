#!/bin/bash

#	base.sh
#	Script to build the 01-core.hsl system layer.
#	This script needs to be executed on a super-light debian
#	installation and update the ./config file to be successful.
#
#	Copyright (C) 2022, huronOS Project:
#		<http://huronos.org>
#
#	Licensed under the GNU GPL Version 2
#		<http://www.gnu.org/licenses/gpl-2.0.html>
#
#	Taken from the Slax project, authored by:
#		Tomas M <http://www.slax.org/>
#		(Original script was ./build)
#
#	Modified and redistributed by the huronOS team:
#		Enya Quetzalli <equetzal@huronos.org>
#		Abraham Omar   <aomm@huronos.org>

export PATH=.:./tools:../tools:/usr/sbin:/usr/bin:/sbin:/bin:/
set -xe

CHANGEDIR="$(dirname "$(readlink -f "$0")")"
echo "Changing current directory to $CHANGEDIR"
cd "$CHANGEDIR"
CWD="$(pwd)"

. ./config || exit 1
. ./livekitlib || exit 1
. ./prepare.sh || exit 1

# only root can continue, because only root can read all files from your system
allow_only_root

# check for mksquashfs with xz compression
if [ "$(mksquashfs 2>&1 | grep "Xdict-size")" = "" ]; then
   echo "mksquashfs not found or doesn't support -comp xz, aborting, no changes made"
   echo "you may consider installing squashfs-tools package"
   exit 1
fi

MKISOFS=$(which mkisofs)
if [ "$MKISOFS" = "" ]; then
   MKISOFS=$(which genisoimage)
fi
if [ "$MKISOFS" = "" ]; then
   echo "Cannot find mkisofs or genisoimage, stop"
   exit 3
fi

# build initramfs image
if [ "$SKIPINITRFS" = "" ]; then
   echo "Building initramfs image..."
   cd initramfs
   INITRAMFS=$(./initramfs_create)
   cd ..
fi

# create live kit filesystem (cpio archive)
rm -Rf "$LIVEKITDATA"
BOOT="$LIVEKITDATA"/boot
EFI="$LIVEKITDATA"/EFI/Boot
FILES="$LIVEKITDATA"/"$LIVEKITNAME"
mkdir -p "$BOOT"
mkdir -p "$EFI"
mkdir -p "$FILES"/base
mkdir -p "$FILES"/data
mkdir -p "$FILES"/data/logs
mkdir -p "$FILES"/data/journal
mkdir -p "$FILES"/data/backups
mkdir -p "$FILES"/data/configs
mkdir -p "$FILES"/software
mkdir -p "$FILES"/software/internet
mkdir -p "$FILES"/software/langs
mkdir -p "$FILES"/software/programming
mkdir -p "$FILES"/software/tools

if [ "$INITRAMFS" != "" ]; then
   mv "$INITRAMFS" "$BOOT"/initrfs.img
fi

# BIOS / MBR booting
cp -r bootloader/legacy/* "$BOOT"
cp "$VMLINUZ" "$BOOT/" || exit

# UEFI booting
cp -rf bootloader/EFI/Boot/syslinux.efi "$EFI"/bootx64.efi
cp -rf bootloader/EFI/Boot/* "$EFI"

## Copy installer
cp tools/installer/install.sh "${LIVEKITDATA}/install.sh"

# create compressed 01-core.sb
COREFS=""
for i in $MKMOD; do
   if [ -d /$i ]; then
      COREFS="$COREFS /$i"
   fi
done
# shellcheck disable=SC2086
mksquashfs $COREFS "$LIVEKITDATA/$LIVEKITNAME/base/01-core.$BEXT" -comp xz -b 1024K -always-use-fragments -keep-as-directory || exit

## Create iso maker util
ARCH="amd64"
TARGET=/tmp
ISO_MAKER="$TARGET/make-iso.sh"
EFI_DIR="./EFI"
BOOT_DIR="./boot"
HURONOS_DIR="./huronOS"
cp tools/make-iso/make-iso.sh "$ISO_MAKER"
sed "s|ISO_DIR=.*|ISO_DIR=\"$LIVEKITDATA\"|g" -i "$ISO_MAKER"
sed "s|ISO_TOOL=.*|ISO_TOOL=\"$MKISOFS\"|g" -i "$ISO_MAKER"
sed "s|ISO_OUTPUT=.*|ISO_OUTPUT=\"$TARGET/$LIVEKITNAME-b$BUILD_YEAR.$BUILD_VERSION-$ARCH.iso\"|g" -i "$ISO_MAKER"
sed "s|EFI_DIR=.*|EFI_DIR=\"$EFI_DIR\"|g" -i "$ISO_MAKER"
sed "s|BOOT_DIR=.*|BOOT_DIR=\"$BOOT_DIR\"|g" -i "$ISO_MAKER"
sed "s|HURONOS_DIR=.*|HURONOS_DIR=\"$HURONOS_DIR\"|g" -i "$ISO_MAKER"

chmod o+x "$ISO_MAKER"

# shellcheck source=/dev/null
. "$CHANGEDIR/restore.sh"

echo "-----------------------------"
echo "Finished. Find your result in $LIVEKITDATA"
echo "To build ISO, run: $ISO_MAKER"
cd "$CWD"

