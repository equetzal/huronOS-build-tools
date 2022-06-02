#!/bin/bash

set -xe

# Install destiny build packages
INST_PACKAGES="acpi-support-base acpid alsa-utils at bzip2 connman curl dnsutils dosfstools file hdparm htop less lsof lzma man ntfs-3g ntpdate parted pm-utils powermgmt-base psmisc rfkill sdparm squashfs-tools usb-modeswitch wget wireless-tools wpasupplicant xz-utils"
DEV_PACKAGES="gddrescue genisoimage gpart net-tools netcat smartmontools unzip zip"
REM_PACKAGES="debconf-i18n dvd+rw-tools dnsmasq installation-report mc mdadm rsync ssh vim-common vim-tiny virt-what grub-common grub-pc-bin grub-pc-bin grub2-common"

apt update
apt install --yes --no-install-recommends $INST_PACKAGES
if [ "$DEVELOPER" = "true" ]; then
	apt install --yes --no-install-recommends $DEV_PACKAGES
else
	apt autoremove --yes --purge $DEV_PACKAGES
fi
apt autoremove --yes --purge $REM_PACKAGES


# Copy root directories
pushd usrroot && cp --parents -afr * / && popd
if [ "$DEVELOPER" = "true" ]; then
	pushd devroot && cp --parents -afr * / && popd
fi

rm -rf /usr/share/wallpapers/

# Create symlinks according to https://wiki.debian.org/Derivatives/Guidelines
ln -sf /etc/dpkg/origins/huronos /etc/dpkg/origins/default
ln -sf /usr/lib/os-release /etc/os-release

## hsync symlinks
ln -sf /usr/lib/systemd/system/hsync.service /etc/systemd/system/hsync.service
ln -sf /usr/lib/systemd/system/hsync.timer /etc/systemd/system/hsync.timer

## Permissions
chmod 640 /etc/fstab
chmod 640 /etc/hmount/rule
chmod 644 /usr/lib/udev/rules.d/80-huronOS-mount.rules
chmod 740 /usr/lib/hmount/hmount.automount
chmod 760 /usr/lib/hsync/*
chmod 660 /usr/lib/systemd/system/hsync*
chmod 660 /usr/lib/systemd/system/happly*
## apt,  