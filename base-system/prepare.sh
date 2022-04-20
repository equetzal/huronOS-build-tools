#!/bin/bash

set -xe

# Install destiny build packages
INST_PACKAGES="acpi-support-base acpid alsa-utils bzip2 connman dnsutils dosfstools file hdparm less lsof lzma man ntfs-3g ntpdate pm-utils powermgmt-base psmisc rfkill sdparm squashfs-tools usb-modeswitch wget wireless-tools wpasupplicant xz-utils"
DEV_PACKAGES="dnsmasq gddrescue genisoimage gpart htop net-tools netcat smartmontools unzip zip"
REM_PACKAGES="debconf-i18n dvd+rw-tools installation-report mc mdadm rsync ssh vim-common vim-tiny virt-what grub-common grub-pc-bin grub-pc-bin grub2-common"

apt update
apt install --yes --no-install-recommends $INST_PACKAGES
if [ "$DEVELOPER" = "true" ]; then
	apt install --yes --no-install-recommends $DEV_PACKAGES
else
	apt remove --yes $DEV_PACKAGES
fi
apt remove --yes $REM_PACKAGES
apt autoclean --yes --purge

# Copy root directories
pushd usrroot && cp --parents -afr * / && popd
if [ "$DEVELOPER" = "true" ]; then
	pushd devroot && cp --parents -afr * / && popd
fi

# Create symlinks according to https://wiki.debian.org/Derivatives/Guidelines
ln -sf /etc/dpkg/origins/huronos /etc/dpkg/origins/default
ln -sf /usr/lib/os-release /etc/os-release

# Replace debian branding with huronOS branding

