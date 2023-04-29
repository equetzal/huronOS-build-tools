#!/bin/bash

#	ruby.sh
#	Script to build the modular software package of Ruby for huronOS.
#	It purges the unnecessary files on the FS to allow AUFS
#	add/del operations on the fly.
#	It includes the documentation for the Ruby programming language.
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
apt install --yes --no-install-recommends ruby

## Prepare final files
mkdir -p /usr/share/doc/reference/ruby/
tar -xvzf reference.tar.gz --strip-components=1 -C /usr/share/doc/reference/ruby/
cp ./ruby-documentation.desktop /usr/share/applications/

## Create packed changes
savechanges /tmp/ruby.hsm

## Clean package to maintain only relevant files
hsm2dir /tmp/ruby.hsm
rm -rf /tmp/ruby.hsm/var
rm -rf /tmp/ruby.hsm/home
rm -rf /tmp/ruby.hsm/root
rm -rf /tmp/ruby.hsm/etc
dir2hsm /tmp/ruby.hsm

cp /tmp/ruby.hsm /run/initramfs/memory/system/huronOS/langs/
