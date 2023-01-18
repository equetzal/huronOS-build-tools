#!/bin/bash

#	prepare.sh
#	Script to prepare the debian system previous to pack the system into
#	the 01-core.hsl.
#
#	Copyright (C) 2022, huronOS Project:
#		<http://huronos.org>
#
#	Licensed under the GNU GPL Version 2
#		<http://www.gnu.org/licenses/gpl-2.0.html>
#
#	Authors:
#		Enya Quetzalli <equetzal@huronos.org>


set -xe

# Install destiny build packages
INST_PACKAGES="acpi-support-base acpid alsa-utils at bc bzip2 connman curl dbus-broker dnsutils dosfstools file firmware-linux hdparm htop iptables kexec-tools less lsof lzma man ntfs-3g ntpdate oomd parted pm-utils powermgmt-base psmisc rfkill sdparm speedtest-cli squashfs-tools systemd-timesyncd traceroute usb-modeswitch wget wireless-tools wpasupplicant xz-utils"
DEV_PACKAGES="gddrescue genisoimage gpart netcat smartmontools unzip zip"
REM_PACKAGES="debconf-i18n dvd+rw-tools dnsmasq installation-report mc mdadm rsync ssh vim-common vim-tiny virt-what grub-common grub-pc-bin grub-pc-bin grub2-common"

apt update
# shellcheck disable=SC2086
apt install --yes --no-install-recommends $INST_PACKAGES
if [ "$DEVELOPER" = "true" ]; then
	# shellcheck disable=SC2086
	apt install --yes --no-install-recommends $DEV_PACKAGES
else
	# shellcheck disable=SC2086
	apt autoremove --yes --purge $DEV_PACKAGES
fi
# shellcheck disable=SC2086
apt autoremove --yes --purge $REM_PACKAGES


# Copy root directories
pushd usrroot && cp --parents -afr * / && popd
if [ "$DEVELOPER" = "true" ]; then
	pushd devroot && cp --parents -afr * / && popd
fi

## Deactivate systemd-networkd
systemctl mask systemd-networkd
systemctl mask systemd-resolved
systemctl enable connman

## Remove unwanted files/dirs
rm -rf /usr/share/wallpapers/
rm -f /var/lib/systemd/random-seed

## Disable lid suspend
sed -i 's/#HandleLidSwitch=.*/HandleLidSwitch=ignore/g' /etc/systemd/logind.conf
sed -i 's/#HandleLidSwitchExternalPower=.*/HandleLidSwitchExternalPower=ignore/g' /etc/systemd/logind.conf
sed -i 's/#HandleLidSwitchDocked=.*/HandleLidSwitchDocked=ignore/g' /etc/systemd/logind.conf

# Create symlinks according to https://wiki.debian.org/Derivatives/Guidelines
ln -sf /etc/dpkg/origins/huronos /etc/dpkg/origins/default
ln -sf /usr/lib/os-release /etc/os-release

## hsync symlinks
ln -sf /usr/lib/systemd/system/hsync.service /etc/systemd/system/hsync.service
ln -sf /usr/lib/systemd/system/happly.service /etc/systemd/system/happly.service
ln -sf /usr/lib/systemd/system/happly-wallpaper.service /etc/systemd/system/happly-wallpaper.service
ln -sf /usr/lib/systemd/system/hsync.timer /etc/systemd/system/hsync.timer
ln -sf /usr/lib/hsync/hsync.sh /usr/lib/hsync/happly.sh

## Permissions
chmod 640 /etc/fstab
chmod 640 /etc/hmount/rule
chmod 644 /usr/lib/udev/rules.d/80-huronOS-mount.rules
chmod 740 /usr/lib/hmount/hmount.sh
chmod 760 /usr/lib/hsync/*
chmod 0644 /usr/lib/systemd/system/hsync*
chmod 0644 /usr/lib/systemd/system/happly*
chmod 760 /usr/sbin/auls
chmod 760 /usr/sbin/hmm
chmod 760 /usr/sbin/hos-*
chmod 760 /usr/sbin/savechanges

## Journal max size
sed -i 's;#SystemMaxUse=.*;SystemMaxUse=300M;1' /etc/systemd/journald.conf