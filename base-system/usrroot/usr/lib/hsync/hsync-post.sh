#!/bin/bash

#	hsync-post.sh (huronOS Directives Syncronizer)
#	--> Please complete description <--
#
#	Copyright (C) 2022, huronOS Project:
#		<http://huronos.org>
#
#	Licensed under the GNU GPL Version 2
#		<http://www.gnu.org/licenses/gpl-2.0.html>	
#
#	Authors:
#		Enya Quetzalli <equetzal@huronos.org>
#		Abraham Omar   <aomm@huronos.org>

set -x

## Set some system vars
export TERM=dumb

## Set some constants
readonly MEMORY=/run/initramfs/memory
readonly SYSTEM_MNT=$MEMORY/system
readonly EVENT_MNT=$MEMORY/event
readonly CONTEST_MNT=$MEMORY/contest
readonly SYSCHANGES=$MEMORY/syschanges
readonly USRCHANGES=$MEMORY/usrchanges
readonly BASE_MNT=$MEMORY/base
readonly MODULES_MNT=$MEMORY/modules
readonly UNION=/
readonly DIRECTIVES_FILE=/etc/hsync/directives
readonly DIRECTIVES_DEFAULT=/etc/hsync/default
readonly DIRECTIVES_FILE_SERVER=/etc/hsync/server
readonly STATE_FILE=/etc/hsync/state
readonly BACKUP_DIR_NAME=.huronOS..sysbackup.d
readonly BACKUP_DIR=$USRCHANGES/$BACKUP_DIR_NAME

## Include libraries of hsync
. /usr/lib/hsync/libhapply.so
. /usr/lib/hsync/libhfirewall.so
. /usr/lib/hsync/libhlog.so
. /usr/lib/hsync/libhpersistence.so
. /usr/lib/hsync/libhrestore.so
. /usr/lib/hsync/libhsystem.so
. /usr/lib/hsync/libhupdate.so


main(){
	log_journal_to_disk
}

main "$@"; exit;

