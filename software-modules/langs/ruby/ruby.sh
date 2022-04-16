#!/bin/sh

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

cp /tmp/ruby.hsm /run/initramfs/memory/data/huronOS/langs/
