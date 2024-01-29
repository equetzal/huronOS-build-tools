#!/bin/bash

. /usr/lib/hos/enviroment.sh

if [ ! -d "$SYSTEM_BUILD_CONTROL_DIR" ] || [ ! -f "$SYSTEM_BUILD_CONTROL_DIR/mount.sh" ] || [ ! -f "$SYSTEM_BUILD_CONTROL_DIR/queue" ]; then
	echo "No build to perform" | tee /dev/tty1
	exit 1 # error
fi

chvt 1 || true

## Mount huronOS-build-tools
. "$SYSTEM_BUILD_CONTROL_DIR/mount.sh"

## Execute the next script in queue
QUEUE="$SYSTEM_BUILD_CONTROL_DIR/queue"
echo "Checking queue for pending build jobs" | tee /dev/tty1

if [ -s "$QUEUE" ]; then
	NEXT_SCRIPT="$(head -n 1 "$QUEUE")"

	## Delete element from queue
	tail -n +2 "$QUEUE" > "$QUEUE.tmp"
	mv "$QUEUE.tmp" "$QUEUE"

	## Launch the script
	chvt 1 || true
	echo "Launching $NEXT_SCRIPT" | tee /dev/tty1
	. "$SYSTEM_BUILD_CONTROL_DIR/$NEXT_SCRIPT" 2>&1 | tee /dev/tty1

	## Now restart the system
	chvt 1 || true
	echo "Restarting system" | tee /dev/tty1
	quick-reboot
else
	chvt 1 || true
	rm -rf "$SYSTEM_BUILD_CONTROL_DIR"
	rm -f "$SYSTEM_BASE_DIR/09*"
	echo "Finished" | tee /dev/tty1
	quick-reboot
fi

