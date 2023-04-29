#!/bin/bash

#	restore.sh
#	Script to restore the grub installation and do not let the system
#	unbootable after the execution of base.sh
#
#	Copyright (C) 2022, huronOS Project:
#		<http://huronos.org>
#
#	Licensed under the GNU GPL Version 2
#		<http://www.gnu.org/licenses/gpl-2.0.html>
#
#	Authors:
#		Enya Quetzalli <equetzal@huronos.org>

RESTORE_PACKAGES="grub-common grub-pc-bin grub-pc-bin grub2-common"

# shellcheck disable=SC2086
apt install --yes --no-install-recommends $RESTORE_PACKAGES
