#!/bin/bash

#	enviroment.sh
#	Set important variables for general huronOS scripts.
#
#	Copyright (C) 2022, huronOS Project:
#		<http://huronos.org>
#
#	Licensed under the GNU GPL Version 2
#		<http://www.gnu.org/licenses/gpl-2.0.html>
#
#	Authors:
#		Enya Quetzalli <equetzal@huronos.org>

## AUFS Mix Lab
export MEMORY="/run/initramfs/memory"

## Disk partitions mounts
export SYSTEM_MNT="$MEMORY/system"
export EVENT_MNT="$MEMORY/event"
export CONTEST_MNT="$MEMORY/contest"

## Important dirs
export SYSTEM_BASE_DIR="$SYSTEM_MNT/huronOS/base"
export SYSTEM_DATA_DIR="$SYSTEM_MNT/huronOS/data"
export SYSTEM_SOFTWARE_DIR="$SYSTEM_MNT/huronOS/software"
export SYSTEM_ROOTCOPY_DIR="$SYSTEM_MNT/huronOS/rootcopy"

## Data dirs
export SYSTEM_CONFIGS_DIR="$SYSTEM_DATA_DIR/configs"
export SYSTEM_BACKUP_FILES_DIR="$SYSTEM_DATA_DIR/backups"
export SYSTEM_JOURNAL_DIR="$SYSTEM_DATA_DIR/journal"
export SYSTEM_LOGS_DIR="$SYSTEM_DATA_DIR/logs"

## Software dirs
export SOFTWARE_INTERNET_DIR="$SYSTEM_SOFTWARE_DIR/internet"
export SOFTWARE_LANGS_DIR="$SYSTEM_SOFTWARE_DIR/langs"
export SOFTWARE_PROGRAMMING_DIR="$SYSTEM_SOFTWARE_DIR/programming"
export SOFTWARE_TOOLS_DIR="$SYSTEM_SOFTWARE_DIR/tools"

## Loopback dirs for squashfs
export BASE_LAYERS_LOOPBACK_DIR="$MEMORY/base"
export SOFTWARE_MODULES_LOOPBACK_DIR="$MEMORY/modules"

## AUFS branches dirs
export UNION="/"
export SYSCHANGES="$MEMORY/syschanges"
export USRCHANGES="$MEMORY/usrchanges"

## Local dirs
export CURRENT_WALLPAPERS_DIR="/usr/share/backgrounds"

## Special files
export DEFAULT_DIRECTIVES_FILE="/etc/hsync/default"
export DEFAULT_WALLPAPER_FILE="/usr/share/backgrounds/huronos-background.png"
export CURRENT_DIRECTIVES_FILE="/etc/hsync/directives"
export CURRENT_STATE_VARIABLES_FILE="/etc/hsync/state-variables"
export CURRENT_STATE_SUMMARY_FILE="/etc/hsync/state-summary"
export CURRENT_SYNC_SERVER_CONFIG_FILE="/etc/hsync/sync-server.conf"

## Special files backup
export BACKUP_DIRECTIVES_FILE="$SYSTEM_BACKUP_FILES_DIR/directives.backup"
export BACKUP_STATE_VARIABLES_FILE="$SYSTEM_BACKUP_FILES_DIR/state-variables.backup"
export BACKUP_STATE_SUMMARY_FILE="$SYSTEM_BACKUP_FILES_DIR/state-summary.backup"


## Make variables readonly
readonly MEMORY
readonly SYSTEM_MNT
readonly EVENT_MNT
readonly CONTEST_MNT
readonly SYSTEM_BASE_DIR
readonly SYSTEM_DATA_DIR
readonly SYSTEM_SOFTWARE_DIR
readonly SYSTEM_ROOTCOPY_DIR
readonly SYSTEM_CONFIGS_DIR
readonly SYSTEM_BACKUP_FILES_DIR
readonly SYSTEM_JOURNAL_DIR
readonly SYSTEM_LOGS_DIR
readonly SOFTWARE_INTERNET_DIR
readonly SOFTWARE_LANGS_DIR
readonly SOFTWARE_PROGRAMMING_DIR
readonly SOFTWARE_TOOLS_DIR
readonly BASE_LAYERS_LOOPBACK_DIR
readonly SOFTWARE_MODULES_LOOPBACK_DIR
readonly UNION
readonly SYSCHANGES
readonly USRCHANGES
readonly CURRENT_WALLPAPERS_DIR
readonly DEFAULT_DIRECTIVES_FILE
readonly CURRENT_DIRECTIVES_FILE
readonly CURRENT_STATE_VARIABLES_FILE
readonly CURRENT_STATE_SUMMARY_FILE
readonly CURRENT_SYNC_SERVER_CONFIG_FILE
readonly BACKUP_DIRECTIVES_FILE
readonly BACKUP_STATE_VARIABLES_FILE
readonly BACKUP_STATE_SUMMARY_FILE