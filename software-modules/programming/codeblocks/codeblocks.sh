#!/bin/sh

apt update
apt install --yes --no-install-recommends codeblocks
apt autoremove --yes

cp ./codeblocks.desktop /usr/share/applications/

savechanges ../../../../huronOS/programming/codeblocks.hsm

