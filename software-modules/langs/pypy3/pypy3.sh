#!/bin/bash

#	pypy3.sh
#	Script to build the modular software package of PyPy 3 for huronOS. 
#	It purges the unnecessary files on the FS to allow AUFS 
#	add/del operations on the fly.
#	It includes the documentation for the Python 3 programming language.
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
apt install --yes --no-install-recommends pypy3

## Prepare final files
mkdir -p /usr/share/doc/reference/python3/
tar -xvzf reference.tar.gz --strip-components=1 -C /usr/share/doc/reference/python3/
cp ./python3-documentation.desktop /usr/share/applications/

## Create packed changes
savechanges /tmp/pypy3.hsm

## Clean package to maintain only relevant files
hsm2dir /tmp/pypy3.hsm
rm -rf /tmp/pypy3.hsm/var
rm -rf /tmp/pypy3.hsm/home
rm -rf /tmp/pypy3.hsm/root
rm -rf /tmp/pypy3.hsm/etc
dir2hsm /tmp/pypy3.hsm

cp /tmp/pypy3.hsm /run/initramfs/memory/system/huronOS/langs/
