#!/bin/bash

#	firmware.sh
#	Script to build the firmware huronOS System Layer (.hsl)
#	for huronOS image. It packs the huronOS' selection
#	of free, open and private firmware to improve the
#	performance of the distribution over several hardware.
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

FIRMWARE="arm-trusted-firmware-tools atmel-firmware bluez bluez-cups bluez-firmware bluez-obexd bluez-tools broadcom-sta-common dahdi-firmware-nonfree firmware-amd-graphics firmware-ath9k-htc firmware-atheros firmware-b43-installer firmware-bnx2 firmware-bnx2x firmware-brcm80211 firmware-cavium firmware-intel-sound firmware-intelwimax firmware-ipw2x00 firmware-ivtv firmware-iwlwifi firmware-libertas firmware-linux firmware-linux-free firmware-linux-nonfree firmware-microbit-micropython firmware-microbit-micropython-doc firmware-misc-nonfree firmware-myricom firmware-netronome firmware-netxen firmware-qcom-media firmware-qcom-soc firmware-qlogic firmware-realtek firmware-samsung firmware-siano firmware-sof-signed firmware-ti-connectivity firmware-tomu firmware-zd1211 hdmi2usb-fx2-firmware mesa-utils mesa-utils-extra mesa-va-drivers:amd64 mesa-vdpau-drivers:amd64 mesa-vulkan-drivers:amd64 midisport-firmware pulseaudio-module-gsettings pulseaudio-module-zeroconf sigrok-firmware-fx2lafw ubertooth-firmware vulkan-tools vulkan-validationlayers:amd64"

apt update
apt install --yes --no-install-recommends "$FIRMWARE"
apt autoremove --yes --purge

savechanges /tmp/02-firmware.hsl
cp /tmp/02-firmware.hsl /run/initramfs/memory/system/huronOS/base --verbose
