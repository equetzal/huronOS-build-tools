#!/bin/bash

FIRMWARE="firmware-linux-free firmware-atheros firmware-iwlwifi firmware-zd1211 firmware-realtek firmware-bnx2 firmware-brcm80211 firmware-cavium firmware-ipw2x00 firmware-libertas firmware-ti-connectivity firmware-b43-installer"

apt update
apt install --yes --no-install-recommends $FIRMWARE

savechanges /02-firmware.hsm
