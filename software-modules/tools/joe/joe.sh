#!/bin/sh

apt update
apt install --yes --no-install-recommends joe
apt autoremove --yes

cp ./joe.desktop /usr/share/applications/

savechanges ../../../../huronOS/tools/joe.hsm
