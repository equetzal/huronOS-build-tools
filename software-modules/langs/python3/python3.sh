#!/bin/sh

mkdir -p /usr/share/doc/python3-documentation/
cp -r ./documentation/* /usr/share/doc/python3-documentation/

cp ./python3-documentation.desktop /usr/share/applications/

savechanges /media/sdb1/huronOS/langs/python3.hsm
