#!/bin/bash

#	sysforge-wizard.sh
#	Script to handle the build queue prepared by sysforge,
#	this script is run at bootime attached to the TTY1.
#	Builds one layer per-boot.
#
#	Copyright (C) 2024, huronOS Project:
#		<http://huronos.org>
#
#	Licensed under the GNU GPL Version 2
#		<http://www.gnu.org/licenses/gpl-2.0.html>
#
#	Authors:
#		Enya Quetzalli <equetzal@huronos.org>

. /usr/lib/hos/enviroment.sh

## Print functions
BOLD="$(tput bold)"
BOLD_GREEN="$(tput setab 2)$(tput bold)"
BOLD_RED="$(tput setab 2)$(tput setaf 1)$(tput bold)"
NORMAL_TEXT="$(tput sgr0)"
print_bold() {
	echo -e "${BOLD}$1${NORMAL_TEXT}" | tee /dev/tty1 -a "$SYSTEM_MNT"/sysforge-wizard.log
}
print_bold_red() {
	echo -e "${BOLD_RED}$1${NORMAL_TEXT}" | tee /dev/tty1 -a "$SYSTEM_MNT"/sysforge-wizard.log
}
print_step() {
	echo -e "${BOLD_GREEN}$1${NORMAL_TEXT}" | tee /dev/tty1 -a "$SYSTEM_MNT"/sysforge-wizard.log
}
print_text() {
	echo -e "$1" | tee /dev/tty1 -a "$SYSTEM_MNT"/sysforge-wizard.log
}
exit_error() {
	print_text "$1"
	echo -e "$1" | tee -a "$SYSTEM_MNT"/sysforge-wizard.errors.log
	exit 1
}

## Check for sysforge prepared directory
chvt 1 || true
print_step "[1/5] Validating build-control"
if [ ! -d "$SYSTEM_BUILD_CONTROL_DIR" ]; then
	print_text "No build-control directory"
	exit 1 # error
fi
if [ ! -f "$SYSTEM_BUILD_CONTROL_DIR/mount.sh" ]; then
	print_text "No automated mount script"
	exit 1 # error
fi
if [ ! -f "$SYSTEM_BUILD_CONTROL_DIR/queue" ]; then
	print_text "No build queue"
	exit 1 # error
fi

## Try to mount huronOS-build-tools
print_step "[2/5] Mounting huronOS-build-tools"
. "$SYSTEM_BUILD_CONTROL_DIR/mount.sh" || exit_error "Error: Could not mount huronOS-build-tools"

## Execute the next script in queue
chvt 1 || true
print_step "[3/5] Processing queue"
QUEUE="$SYSTEM_BUILD_CONTROL_DIR/queue"

if [ -s "$QUEUE" ]; then
	NEXT_SCRIPT="$(head -n 1 "$QUEUE")"

	## Delete element from queue
	tail -n +2 "$QUEUE" > "$QUEUE.tmp"
	mv "$QUEUE.tmp" "$QUEUE"

	## Try to keep the foreground console here instead of lightdm
	(for _ in {1..10}; do sleep 1 && chvt 1; done)&

	## Only launch the script if we do have DNS connectivity
	while ! ping -c 1 -W 1 1.1.1.1; do
		print_text "Waiting for DNS to become available..."
		sleep 1
	done

	## Launch the script
	print_step "[4/5] Processing script $NEXT_SCRIPT."
	export DEBIAN_FRONTEND=noninteractive
	. "$SYSTEM_BUILD_CONTROL_DIR/$NEXT_SCRIPT" 2>&1 | tee /dev/tty1 -a "$SYSTEM_MNT"/sysforge-wizard.log || exit_error "Error: while running $NEXT_SCRIPT"

	## Now restart the system
	chvt 1 || true
	print_step "[5/5] Reboot"
	quick-reboot
else
	chvt 1 || true
	print_step "[4/5] Empty queue, disabling sysforge wizard."
	rm -rf "$SYSTEM_BUILD_CONTROL_DIR"
	rm -rf "$SYSTEM_BASE_DIR/09-sysforge-wizard.hsl"
	
	chvt 1 || true
	print_step "[5/5] Reboot"
	quick-reboot
fi

