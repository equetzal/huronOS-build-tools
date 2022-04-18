#!/bin/sh

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

cp /tmp/g++.hsm /run/initramfs/memory/data/huronOS/langs/