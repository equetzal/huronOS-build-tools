#!/bin/bash

#	save.sh
#	Script to pack the huronOS System Layer for budgie.
#
#	Copyright (C) 2022, huronOS Project:
#		<http://huronos.org>
#
#	Licensed under the GNU GPL Version 2
#		<http://www.gnu.org/licenses/gpl-2.0.html>
#
#	Authors:
#		Enya Quetzalli <equetzal@huronos.org>

savechanges /tmp/03-budgie.hsl
cp /tmp/03-budgie.hsl /run/initramfs/memory/system/huronOS/base --verbose