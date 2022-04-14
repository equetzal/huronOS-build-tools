#!/bin/sh

apt update
apt install --yes --no-install-recommends konsole
apt autoremove --yes

cp ./konsole.desktop /usr/share/applications/
rm org.kde.konsole.desktop

savechanges ../../../../huronOS/tools/konsole.hsm
