#!/bin/bash

#	java.sh
#	Script to build the modular software package of Java for huronOS.
#	It purges the unnecessary files on the FS to allow AUFS
#	add/del operations on the fly.
#	It includes the documentation for the Java language.
#
#	Copyright (C) 2022, huronOS Project:
#		<http://huronos.org>
#
#	Licensed under the GNU GPL Version 2
#		<http://www.gnu.org/licenses/gpl-2.0.html>
#
#	Authors:
#		Daniel Cerna <dcerna@huronos.org>

set -xe
NAME=javac
TARGET_DIR="/run/initramfs/memory/system/huronOS/software/langs/"

## Install software
apt update
apt install --yes --no-install-recommends openjdk-17-jdk
apt autoremove --yes

## Prepare final files
mkdir -p /usr/share/doc/reference/java/
tar -xvzf reference.tar.gz -C /usr/share/doc/reference/java/ --strip-components=1
cp ./java-documentation.desktop /usr/share/applications/

## Create packed changes
savechanges /tmp/$NAME.hsm

## Clean package to maintain only relevant files
hsm2dir /tmp/$NAME.hsm
cd /tmp/$NAME.hsm

# Array to store paths to exclude that contain java things
declare -a EXCLUDE_PATHS=(
    "./etc/.java/*"
    "./etc/alternatives/*"
    "./etc/java-11-openjdk/*"
    "./etc/java-17-openjdk/*"
    "./etc/ssl/*"
    "./usr/bin/*"
    "./usr/lib/*"
    "./usr/lib/jvm/*"
    "./usr/sbin/update-java-alternatives*"
    "./usr/share/applications/java-documentation.desktop*"
    "./usr/share/bash-completion/completions/update-java-alternatives*"
    "./usr/share/ca-certificates-java/*"
    "./usr/share/doc/*"
    "./usr/share/gdb/auto-load/usr/lib/jvm/*"
    "./usr/share/gtksourceview-4/language-specs/*"
    "./usr/share/java/*"
    "./usr/share/lintian/*"
    "./usr/share/man/man1/*"
    "./usr/share/man/man8/*"
    "./usr/share/maven-repo/*"
    "./usr/share/mime/*"
    "./usr/share/nano/*"
    "./usr/share/netbeans/platform18/*"
    "./usr/share/nvim/runtime/*"
    "./usr/share/source-highlight/*"
)

# Construct the find command with the paths to exclude
FIND_WITH_EXCLUDED_PATHS="find ."
for EXCLUDED_PATH in "${EXCLUDE_PATHS[@]}"; do
    FIND_WITH_EXCLUDED_PATHS+=" ! -path \"$EXCLUDED_PATH\""
done
REMOVE_UNWANTED_FILES_CMD="$FIND_WITH_EXCLUDED_PATHS -type f -delete"
REMOVE_EMPTY_FOLDERS_CMD="$FIND_WITH_EXCLUDED_PATHS -type d -empty -delete"

# Remove unwanted files
eval "$REMOVE_UNWANTED_FILES_CMD"
# Remove empty folders after removing the unwanted files
eval "$REMOVE_EMPTY_FOLDERS_CMD"

# Exit the hsm directory so it does not give issues
# while converting back the folder to an hsm
cd ..
dir2hsm /tmp/$NAME.hsm

cp /tmp/$NAME.hsm "$TARGET_DIR"
echo "Finished creating $NAME.hsm!"
