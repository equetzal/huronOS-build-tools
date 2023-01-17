#!/bin/bash

# Recreate fstab entries in /etc/fstab and make /media directories
# This script is called by udev rules, see /lib/udev/rules.d/
# This script considers the huronOS directives to decide when to autmount devices.


# Taken from Slax Originally authored by: Tomas M <http://www.slax.org/>
# Modified by the huronOS team:
#  Enya Quetzalli <equetzal@huronos.org>


# Variables available in udev environment:
# $ACTION (eg: add, remove)
# $DEVNAME (full device node name including path)
# $DEVTYPE (eg: disk)
# $ID_FS_TYPE (eg: ext3)
# $MAJOR and $MINOR numbers
# $SUBSYSTEM (eg: block)

set -x

PATH=$PATH:/usr/bin:/usr/sbin:/bin:/sbin

## Get the huronos.flags cmdline value for a given key
# $1 = key to search value of
# Eg. $1="ip", "ip=1.1.1.1" -> "1.1.1.1"
cmdline_value(){
   	cat /proc/cmdline | sed "s/.*huronos.flags=(\(.*\)).*/\1/" | sed -ne "/.*$1=\([^;]*\).*/!d;s//\1/p"
}

BAS="$(basename "$DEVNAME")"
LABEL="$(echo $ID_FS_LABEL | sed 's%-%_%g')"
UNIT="media-$LABEL.mount"
MNT="/media/$LABEL"
TARGET="/etc/systemd/system/$UNIT"
OPTIONS="rw,sync,nosuid,dev,noexec,user,users,noauto,relatime"
OWNER="uid=1000"

TMP_SYSTEM_UUID="$(cmdline_value system.uuid)"
TMP_EVENT_UUID="$(cmdline_value event.uuid)"
TMP_CONTEST_UUID="$(cmdline_value contest.uuid)"
HOS_DRIVES="$(blkid | grep -E "$TMP_SYSTEM_UUID|$TMP_EVENT_UUID|$TMP_CONTEST_UUID" | cut -d: -f1 | cut -d/ -f3 | tr '\n' '|')"

## Avoid mounting huronOS-usb partitions
if echo "$BAS" | grep -E "${HOS_DRIVES}popo"; then
	echo "Skipping the mount of $DEVNAME";
	exit
fi

if [ "$ACTION" = "add" -o "$ACTION" = "change" ]; then

	## Allow new mounts only if current rule allows them
	if cat /etc/hmount/rule; then
		declare $(head -n 1 /etc/hmount/rule);
		if [ "$ShouldMount" = "true" ]; then
			echo "Allowing the mount of $DEVNAME";
		else
			echo "Denying the mount of $DEVNAME";
			exit
		fi
	fi

	## Unit should not exists
	if [ ! -r "$TARGET" ]; then
		if [ "$ID_FS_TYPE" != "" -a "$(cat /proc/filesystems | grep "$ID_FS_TYPE")" != "" ] || [ "$ID_FS_TYPE" = "ntfs" ]; then

			## If the file system es FAT32 (pretty common), use OWNER as FAT32 is not POSIX compatible
			if [ "$ID_FS_TYPE" = "vfat" ]; then
				OPTIONS="${OPTIONS},${OWNER}"
			elif [ "$ID_FS_TYPE" = "ntfs" ]; then
				OPTIONS="${OPTIONS},${OWNER}"
			fi

			## Create directory for the mount point, transfer rights to contestant
			install -d -m 0755 -o contestant -g contestant "$MNT"

			## Create a mount unit for systemd to automount it
			cat <<EOT >> $TARGET
## hmount-rule:do_not_save_on_persistence
[Unit]
Description=Disk $BAS

[Mount]
What=$DEVNAME
Where=$MNT
Type=$ID_FS_TYPE
Options=$OPTIONS

[Install]
WantedBy=multi-user.target
EOT

			## Allow contestant user to mount or umount using suid bit
			echo "$DEVNAME $MNT $ID_FS_TYPE $OPTIONS 0 0" >> /etc/fstab
			
			## Do the automount with systemd
			systemctl enable $UNIT
			systemctl start $UNIT

			## If filesystem is POSIX, reasign ownership
			chown -R contestant:contestant "$MNT"

			## Open the file explorer with the mounted unit
			su contestant -c "export DISPLAY=:0; (nautilus -w file://$MNT >/dev/null 2>&1 &)"
		fi
	fi
fi

if [ "$ACTION" = "remove" ]; then
	## Remove the fstab rule to avoid using unauthorized suid
	sed "s%.*$MNT.*%%g" -i /etc/fstab

	## Tell systemd to disable the .mount unit
	systemctl disable $UNIT

	## Remove the files and directories used
	rm "$TARGET"
	rmdir "$MNT"
fi
