#!/bin/sh

apt update
apt install --yes --no-install-recommends gcc
apt autoremove --yes

mkdir -p /usr/share/doc/reference
cp -r ./reference/* /usr/share/doc/reference/

cp ./c-documentation.desktop /usr/share/applications/

savechanges /media/sdb1/huronOS/programming/gcc.hsm
