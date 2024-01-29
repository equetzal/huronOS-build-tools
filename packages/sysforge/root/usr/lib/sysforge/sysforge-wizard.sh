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
print_bold() {
	echo -e "${BOLD}$1${NORMAL_TEXT}" | tee /dev/tty1
}
print_bold_red() {
	echo -e "${BOLD_RED}$1${NORMAL_TEXT}" | tee /dev/tty1
}
print_step() {
	echo -e "${BOLD_GREEN}$1${NORMAL_TEXT}" | tee /dev/tty1
}

## Check for sysforge prepared directory
chvt 1 || true
print_step "[1/5] Validating build-control"
if [ ! -d "$SYSTEM_BUILD_CONTROL_DIR" ]; then
	echo "No build-control directory" | tee /dev/tty1
	exit 1 # error
fi
if [ ! -f "$SYSTEM_BUILD_CONTROL_DIR/mount.sh" ]; then
	echo "No automated mount script" | tee /dev/tty1
	exit 1 # error
fi
if [ ! -f "$SYSTEM_BUILD_CONTROL_DIR/queue" ]; then
	echo "No build queue" | tee /dev/tty1
	exit 1 # error
fi

## Try to mount huronOS-build-tools
print_step "[2/5] Mounting huronOS-build-tools"
. "$SYSTEM_BUILD_CONTROL_DIR/mount.sh"

## Execute the next script in queue
chvt 1 || true
print_step "[3/5] Processing queue"
QUEUE="$SYSTEM_BUILD_CONTROL_DIR/queue"

if [ -s "$QUEUE" ]; then
	NEXT_SCRIPT="$(head -n 1 "$QUEUE")"

	## Delete element from queue
	tail -n +2 "$QUEUE" > "$QUEUE.tmp"
	mv "$QUEUE.tmp" "$QUEUE"

	## Launch the script
	chvt 1 || true
	print_step "[4/5] Processing system-layer $NEXT_SCRIPT."
	. "$SYSTEM_BUILD_CONTROL_DIR/$NEXT_SCRIPT" 2>&1 | tee /dev/tty1

	## Now restart the system
	chvt 1 || true
	print_step "[5/5] Reboot"
	quick-reboot
else
	chvt 1 || true
	print_step "[4/5] Empty queue, preparing system to first-boot."
	rm -rf "$SYSTEM_BUILD_CONTROL_DIR"
	rm -f "$SYSTEM_BASE_DIR/09*"
	
	chvt 1 || true
	print_step "[5/5] Reboot"
	quick-reboot
fi

