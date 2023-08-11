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
mapfile -t INST_PACKAGES <deps-install.txt
mapfile -t DEV_PACKAGES <deps-dev.txt
mapfile -t REM_PACKAGES <deps-remove.txt

cp -rf usrroot/etc/apt/* /etc/apt/ 
apt update
apt autoremove --yes --purge "${REM_PACKAGES[@]}"
apt install --yes --no-install-recommends "${INST_PACKAGES[@]}"
if [ "$DEVELOPER" = "true" ]; then
	apt install --yes --no-install-recommends "${DEV_PACKAGES[@]}"
else
	apt autoremove --yes --purge "${DEV_PACKAGES[@]}"
fi

# Copy root directories
pushd usrroot && cp --parents -afr * / && popd
if [ "$DEVELOPER" = "true" ]; then
	pushd devroot && cp --parents -afr * / && popd
fi

## Copy tools
cp tools/quick-reboot/quick-reboot /usr/sbin/

## Deactivate systemd-networkd
systemctl mask systemd-networkd
systemctl mask systemd-resolved

## Install connman
apt --yes install connman
systemctl enable connman

## Gives default permisions to earlyom
chmod 400 /etc/default/earlyoom
systemctl enable earlyoom

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
chmod 755 /usr/bin/systembus-notify
chmod 700 /usr/sbin/quick-reboot

## Journal max size
sed -i 's;#SystemMaxUse=.*;SystemMaxUse=300M;1' /etc/systemd/journald.conf
