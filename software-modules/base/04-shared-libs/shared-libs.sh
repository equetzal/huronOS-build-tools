#!/bin/bash

#	shared-libs.sh
#	Script to build the shared-libs huronOS System Layer (.hsl)
#	for huronOS image. It packs the huronOS' selection
#	of dependencies required by the ICPC/IOI software rules.
#	This layer reduces the amount of duplicated dependencies
#	once overlayed the software modular packages.
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

## Get the dependencies and replace every new line with a space
DEPENDENCIES="$(tr <dependencies.txt '\n' ' ')"
apt update
apt install --yes --no-install-recommends $DEPENDENCIES

## Recompile gschemas
glib-compile-schemas /usr/share/glib-2.0/schemas/

savechanges /tmp/04-shared-libs.hsl
cp /tmp/04-shared-libs.hsl /run/initramfs/memory/system/huronOS/base --verbose
