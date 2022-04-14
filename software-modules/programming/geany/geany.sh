#!/bin/sh

apt update
apt install --yes --no-install-recommends geany
apt autoremove --yes

cp ./geany.desktop /usr/share/applications/

savechanges ../../../../huronOS/programming/geany.hsm
