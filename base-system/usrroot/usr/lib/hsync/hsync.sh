#!/bin/bash

#	hsync.sh (huronOS Directives Syncronizer)
#	This script is executed by the hsync.service and the happly.service
#	to maintain the system configurations, persistence disks, firewall,
#	software and directives syncronized with the huronOS directives server.
#	When executed by:
#		hsync.service, the --routine-sync flag will be present.
#			This means that the execution is a regular sync for directives,
#			and directives might not be applied if the directives file has
#			not changed yet.
#		happly.service, the --scheduled-apply flag will be present.
#			This means that the directives needs to be applied now and
#			set the system state to the one stipulated on the directives.
#	This script, uses another own-created bash libraries for it's
#	execution and they are necesary to correctly execute this driver script.
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

## AUFS Mix Lab
readonly MEMORY=/run/initramfs/memory

## Disk partitions mounts
readonly SYSTEM_MNT=$MEMORY/system
readonly EVENT_MNT=$MEMORY/event
readonly CONTEST_MNT=$MEMORY/contest

## Persistence branches to bind
readonly SYSCHANGES=$MEMORY/syschanges
readonly USRCHANGES=$MEMORY/usrchanges

## Loopback dirs for squashfs
readonly BASE_MNT=$MEMORY/base
readonly MODULES_MNT=$MEMORY/modules

## Data dirs
readonly DATA_DIR="$SYSTEM_MNT/huronOS/data"
readonly CONFIGS_DIR="$DATA_DIR/configs"
readonly DIRECTIVES_DIR="$DATA_DIR/directives"
readonly FILES_DIR="$DATA_DIR/backups"
readonly JOURNAL_DIR="$DATA_DIR/journal"
readonly LOGS_DIR="$DATA_DIR/logs"

readonly UNION=/

## Special files
readonly DIRECTIVES_FILE=/etc/hsync/directives
readonly DIRECTIVES_DEFAULT=/etc/hsync/default
readonly DIRECTIVES_FILE_SERVER=/etc/hsync/server
readonly CURRENT_SYNC_SERVER_CONFIG_FILE="$CONFIGS_DIR/sync-server.conf"
readonly STATE_FILE=/etc/hsync/state
readonly BACKUP_DIR_NAME=.huronOS..sysbackup.d
readonly BACKUP_DIR=$USRCHANGES/$BACKUP_DIR_NAME


## Set some global variables

	declare EXECUTION_IS_SCHEDULED_APPLY
	declare EXECUTION_IS_ROUTINE
	declare EXECUTION_NEXT_SCHEDULED_APPLY_TIME
	declare HAS_CLOCK_CHANGED_SINCE_LAST_SYNC

	# STATE preffix is the current state that the system have.
	declare STATE_IS_CLOCK_SYNC
	declare STATE_MODE
	declare STATE_MODE_START_TIME_UTC
	declare STATE_MODE_END_TIME_UTC
	declare STATE_IS_PERSISTENCE_ENABLED
	declare STATE_PERSISTENCE_DISK
	declare STATE_LAST_HSYNC_EXECUTION_TIME_UTC

	# NEW preffix is for intermediate variables to set the new
	# state.
	declare NEW_MODE
	declare NEW_MODE_START_TIME_UTC
	declare NEW_MODE_END_TIME_UTC
	declare NEW_PERSISTENCE_DISK

	# DIRECTIVES preffix is the information about the directives file
	declare DIRECTIVES_FILE_URL
	declare DIRECTIVES_SERVER_IP
	declare DIRECTIVES_TEMP_FILE
	declare DIRECTIVES_FILE_TO_USE
	declare DIRECTIVES_SPECIFIC_CONFIG
	declare DIRECTIVES_HAVE_CHANGED=1
	declare DIRECTIVES_GLOBAL_CONFIG_HAVE_CHANGED=0
	declare DIRECTIVES_ALWAYS_CONFIG_HAVE_CHANGED=0
	declare DIRECTIVES_EVENT_CONFIG_HAVE_CHANGED=0
	declare DIRECTIVES_CONTEST_CONFIG_HAVE_CHANGED=0
	declare DIRECTIVES_EVENT_TIMES_HAVE_CHANGED=0
	declare DIRECTIVES_CONTEST_TIMES_HAVE_CHANGED=0


## Include libraries of hsync
. /usr/lib/hsync/libhapply.so
. /usr/lib/hsync/libhfirewall.so
. /usr/lib/hsync/libhlog.so
. /usr/lib/hsync/libhpersistence.so
. /usr/lib/hsync/libhrestore.so
. /usr/lib/hsync/libhsystem.so
. /usr/lib/hsync/libhupdate.so


main(){
	log_start
	apply_demo_if_on
	check_execution_arguments "$@"

	# Hsync is executed every 1 minute to mantain the system updated acording to the directives file
	# but, the first execution after boot is crucial to know if the system needs to restore it state
	# before boot, or if it will take a new configuration. If no persistence was set on boot, then we
	# should not do anything.
	if system_has_just_booted && system_has_persistece_enabled; then
		# Try to rescue directives and state from the event or contest partition
		# and restore that files to the /etc/hsync/ directory. Useful when system
		# does not have internet yet. If there was no previous state, then no
		# persistence was set, the system was newly-installed, or it was cleaned.
		restore_state_from_disk
		load_state

		# If the system clock is sync to an ntp server, we want to save that into the system state
		# as it is crucial to decide in which mode we should but the huronOS on.
		state_clock_sync
		start_persistence

		# Enable network interfaces before atempting a download.
		# Only at boot as they're not supposed to be deactivated, only root can do that.
		enable_network_interfaces

		# Let's try to download a new directives file, there might be an update to
		# the one restored from the disk. If there is an update, then let's use
		# this new directives
		if try_directives_download && have_directives_changed; then
			update_directives
		fi

		# The system has just booted, so there's no directives applied!
		# Let's always run directives on boot to set a current state.
		apply_directives_to_system
		state_hsync_execution_time
		save_state
		backup_state_to_disk
		log_end
		exit
	fi

	# We need to load our disk state to take the right decitions when updating the directives
	load_state
	state_clock_sync

	# Hsync is being executed after boot, so we will only apply the directives if
	# the directives have changed.
	if try_directives_download && have_directives_changed; then
		update_directives
		apply_directives_to_system
	elif is_execution_scheduled_apply; then
		apply_directives_to_system
	elif [ "$HAS_CLOCK_CHANGED_SINCE_LAST_SYNC" = "yes" ]; then
		log "Re-apply directives due to system clock change"
		apply_directives_to_system
	fi

	# Save the state of the system on the state file so that we can handle correctly future
	# mode changes or backup for restoration. This must be saved AFTER aply the directives,
	# otherwise the previous state can be lost and end in a wrong application of the directives.
	state_hsync_execution_time
	save_state

	# If persistence is enabled, then we can save the huronOS state on the drive
	# to then being allowed to restore it.
	if system_has_persistece_enabled; then
		backup_state_to_disk
	fi
	log_end
}

is_execution_scheduled_apply(){
	if [ "$EXECUTION_IS_SCHEDULED_APPLY" = "true" ]; then
		return 0 # true
	fi
	return 1 # false
}

check_execution_arguments(){
	case $1 in
		"--help") exit ;;
		"--scheduled-apply") EXECUTION_IS_SCHEDULED_APPLY="true";;
		"--routine-sync") EXECUTION_IS_ROUTINE="true";;
		*) exit;;
	esac

	log "+Running hsync,
	IS_SCHEDULED_FORCED_APPLY=$EXECUTION_IS_SCHEDULED_APPLY
	IS_ROUTINE_SYNC=$EXECUTION_IS_ROUTINE"
}

main "$@"; exit;

