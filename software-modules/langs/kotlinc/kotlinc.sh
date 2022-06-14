#!/bin/bash

#	kotlinc.sh
#	Script to build the modular software package of Kotlin
#	Compiler for huronOS. 
#	It purges the unnecessary files on the FS to allow AUFS 
#	add/del operations on the fly.
#	It includes the documentation for the Kotlin programming language.
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
NAME=kotlinc

## Prepare software
unzip ./kotlin-compiler-1.6.21.zip -d /tmp/compiler/
mkdir -p /tmp/$NAME.hsm/
mkdir -p /tmp/$NAME.hsm/usr/bin/
mkdir -p /tmp/$NAME.hsm/usr/lib/kotlinc/
mkdir -p /tmp/$NAME.hsm/usr/share/applications/
mkdir -p /tmp/$NAME.hsm/usr/share/doc/reference/kotlinc/
cp -rf /tmp/compiler/kotlinc/bin/* /tmp/$NAME.hsm/usr/bin/
cp -rf /tmp/compiler/kotlinc/lib/* /tmp/$NAME.hsm/usr/lib/
cp -rf /tmp/compiler/kotlinc/license /tmp/$NAME.hsm/usr/lib/kotlinc/
cp -rf ./kotlin-reference.pdf /tmp/$NAME.hsm/usr/share/doc/reference/kotlinc/
cp ./kotlin-documentation.desktop /tmp/$NAME.hsm/usr/share/applications/

## Clean package to maintain only relevant files
rm -rf /tmp/$NAME.hsm/usr/bin/*.bat
rm -rf /tmp/compiler/
dir2hsm /tmp/$NAME.hsm

cp /tmp/$NAME.hsm /run/initramfs/memory/system/huronOS/langs/
echo "Finished creating $NAME.hsm!"
