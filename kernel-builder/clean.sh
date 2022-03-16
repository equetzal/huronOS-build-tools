#!/bin/bash

#	clean.sh
#	Cleaner for all the installed utilities used to build the kernel
#	Author: Enya Quetzalli <enya@quetza.ly>

apt remove --yes $PACKAGES
apt autoremove --purge --yes
apt clean --yes
