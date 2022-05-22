#!/bin/bash

# Huron Sync Script
# This tool, is the driver script to be executed by the hsync.service systemd-unit.
# It manages the correct application of the directives for huronOS and keep it 
# synchronized.

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
readonly DIRECTIVES_FILE_SERVER=/etc/hsync/server
readonly STATE_FILE=/etc/hsync/state
readonly BACKUP_DIR_NAME=.huronOS..sysbackup.d
readonly BACKUP_DIR=$USRCHANGES/$BACKUP_DIR_NAME


## Set some global variables

	# STATE preffix is the current state that is being applied.
	# they're set along the process and the writted to disk
	declare STATE_IS_CLOCK_SYNC
	declare STATE_MODE
	declare STATE_MODE_START_TIME_UTC
	declare STATE_MODE_END_TIME_UTC
	declare STATE_IS_PERSISTENCE_ENABLED
	declare STATE_PERSISTENCE_DISK
	declare STATE_LAST_HSYNC_EXECUTION_TIME_UTC

	# DISK_STATE preffix is the last state that was writted to disk
	# it is used to change the system state to a newer one.
	declare DISK_STATE_IS_CLOCK_SYNC
	declare DISK_STATE_MODE
	declare DISK_STATE_MODE_START_TIME_UTC
	declare DIKS_STATE_MODE_END_TIME_UTC
	declare DISK_STATE_IS_PERSISTENCE_ENABLED
	declare DISK_STATE_PERSISTENCE_DISK
	declare DISK_STATE_LAST_HSYNC_EXECUTION_TIME_UTC

	# DIRECTIVES preffix is the information about the directives file
	declare DIRECTIVES_FILE_URL
	declare DIRECTIVES_TEMP_FILE
	declare DIRECTIVES_HAVE_CHANGED
	declare DIRECTIVES_GLOBAL_CONFIG_HAVE_CHANGED
	declare DIRECTIVES_ALWAYS_CONFIG_HAVE_CHANGED
	declare DIRECTIVES_EVENT_CONFIG_HAVE_CHANGED
	declare DIRECTIVES_CONTEST_CONFIG_HAVE_CHANGED
	declare DIRECTIVES_EVENT_TIMES_HAVE_CHANGED
	declare DIRECTIVES_CONTEST_TIMES_HAVE_CHANGED


## Include libraries of hsync
. /usr/lib/hsync/libhapply.so
. /usr/lib/hsync/libhlog.so
. /usr/lib/hsync/libhpersistence.so
. /usr/lib/hsync/libhrestore.so
. /usr/lib/hsync/libhsystem.so
. /usr/lib/hsync/libhupdate.so


main(){
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
		backup_state_to_disk
		save_state
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
}

main "$@"; exit;

