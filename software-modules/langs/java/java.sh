#!/bin/bash

#	java.sh
#	Script to build the modular software package of Java
#   for huronOS.
#	It purges the unnecessary files on the FS to allow AUFS
#	add/del operations on the fly.
#	It includes the documentation for the Java language.
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
apt install --yes --no-install-recommends openjdk-17-jdk
apt autoremove --yes

## Prepare final files
mkdir -p /usr/share/doc/reference/java/
tar -xvzf reference.tar.gz -C /usr/share/doc/reference/java/ --strip-components=1
cp ./java-documentation.desktop /usr/share/applications/

## Create packed changes
savechanges /tmp/javac.hsm

## Clean package to maintain only relevant files
hsm2dir /tmp/javac.hsm
cd /tmp/javac.hsm
find . ! -path "./usr/lib/jvm*" ! -path "./usr/bin*" ! -path "./usr/share/icons*" ! -path "./usr/share/man*" ! -path "./usr/share/pixmaps*" ! -path "./etc/alternatives*" ! -path "./usr/share/application-registry*" ! -path "./usr/share/lintian*" ! -path "./usr/share/applications/java-documentation.desktop" ! -path "./usr/share/doc/reference/java*" -delete
dir2hsm /tmp/javac.hsm

cp /tmp/javac.hsm /run/initramfs/memory/system/huronOS/langs/
