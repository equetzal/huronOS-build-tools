#!/bin/bash

RESTORE_PACKAGES="grub-common grub-pc-bin grub-pc-bin grub2-common"
apt install --yes --no-install-recommends $RESTORE_PACKAGES
