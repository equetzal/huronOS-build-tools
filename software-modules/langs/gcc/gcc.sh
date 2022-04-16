#!/bin/sh

set -xe

## Install software
apt update
apt install --yes --no-install-recommends gcc
apt autoremove --yes

## Prepare final files
mkdir -p /usr/share/doc/reference/c/
tar -xvzf reference.tar.gz -C /usr/share/doc/reference/c/ --strip-components=1
cp ./c-documentation.desktop /usr/share/applications/

## Create packed changes
savechanges /tmp/gcc.hsm

## Clean package to maintain only relevant files
hsm2dir /tmp/gcc.hsm
rm -rf /tmp/gcc.hsm/var
rm -rf /tmp/gcc.hsm/etc
rm -rf /tmp/gcc.hsm/root
rm -rf /tmp/gcc.hsm/home
dir2hsm /tmp/gcc.hsm

cp /tmp/gcc.hsm /run/initramfs/memory/data/huronOS/langs/
