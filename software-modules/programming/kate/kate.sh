#!/bin/sh

apt update
apt install --yes --no-install-recommends kate
apt autoremove --yes

cp ./kate.desktop /usr/share/applications/

savechanges ../../../../huronOS/programming/kate.hsm
