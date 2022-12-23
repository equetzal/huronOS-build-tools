#!/bin/bash

#	dependencies.sh
#	Script to log the APT install simulation install
#	of all the selected packages for the budgie'
#	huronOS System Layer. It is used to extract
#	the list of dependencies based on the firmware layer.
#
#	Copyright (C) 2022, huronOS Project:
#		<http://huronos.org>
#
#	Licensed under the GNU GPL Version 2
#		<http://www.gnu.org/licenses/gpl-2.0.html>	
#
#	Authors:
#		Enya Quetzalli <equetzal@huronos.org>

declare "$(head -n 1 ./create.sh)"

for PKG in $PACKAGES; do
	apt -s install $PKG | tee dependencies/$PKG.log
done