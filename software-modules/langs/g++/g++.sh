#!/bin/bash

#	g++.sh
#	Script to build the modular software package of GNU
#	Compiler Collection with only g++ compiler for huronOS. 
#	It purges the unnecessary files on the FS to allow AUFS 
#	add/del operations on the fly.
#	It includes the documentation for the C++ programming language.
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

## Install software
apt update
apt install --yes --no-install-recommends g++
apt autoremove --yes

## Prepare final files
mkdir -p /usr/share/doc/reference/c++/
tar -xvzf reference.tar.gz --strip-components=1 -C /usr/share/doc/reference/c++/
cp ./c++-documentation.desktop /usr/share/applications/

## Create packed changes
savechanges /tmp/g++.hsm

## Clean package to maintain only relevant files
hsm2dir /tmp/g++.hsm
rm -rf /tmp/g++.hsm/var
rm -rf /tmp/g++.hsm/etc
rm -rf /tmp/g++.hsm/root
rm -rf /tmp/g++.hsm/home
rm -f /tmp/g++.hsm/usr/bin/*gcc*
dir2hsm /tmp/g++.hsm

cp /tmp/g++.hsm /run/initramfs/memory/system/huronOS/langs/
