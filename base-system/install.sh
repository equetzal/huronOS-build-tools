#!/bin/bash

PACKAGES="squashfs-tools genisoimage zip xz-utils lzma"

apt update
apt install --yes --no-install-recommends $PACKAGES
