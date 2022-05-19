#!/bin/sh

set -xe

## Install software
# Python3 is special case, it is dependency for budgie, so we will need to manage it with permissions.

## Prepare final files
mkdir -p /usr/share/doc/reference/python3/
tar -xvzf reference.tar.gz --strip-components=1 -C /usr/share/doc/reference/python3/
cp ./python3-documentation.desktop /usr/share/applications/

## Create packed changes
savechanges /tmp/python3.hsm

## Clean package to maintain only relevant files
hsm2dir /tmp/python3.hsm
rm -rf /tmp/python3.hsm/var
rm -rf /tmp/python3.hsm/home
rm -rf /tmp/python3.hsm/root
rm -rf /tmp/python3.hsm/etc
dir2hsm /tmp/python3.hsm

cp /tmp/python3.hsm /run/initramfs/memory/system/huronOS/langs/
