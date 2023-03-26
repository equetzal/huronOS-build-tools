#!/bin/bash

#	install.sh
#	Script to select, partition, format, configure and install
#	huronOS on a removable USB storage device.
#
#	Copyright (C) 2022, huronOS Project:
#		<http://huronos.org>
#
#	Licensed under the GNU GPL Version 2
#		<http://www.gnu.org/licenses/gpl-2.0.html>
#
#	Authors:
#		Enya Quetzalli <equetzal@huronos.org>

# $1 = message to print
print_step(){
	echo -e "$(tput setab 2)$(tput bold)$1$(tput sgr0)"
}

print_step "Starting huronOS installation"

## Save the directory where the script is running, it should match the ISO of huronOS
ISO_DIR="$(dirname "$(readlink -f "$0")")"
print_step "[1/10] Locating huronOS image -> $ISO_DIR"

## Configure the remote directives file
print_step "[2/10] Configuring directives server."
TMP_SERVER_CONFIG="/tmp/$$-sync-server.conf"
read -r -p "URL (http/s) of directives file to configure:" DIRECTIVES_FILE_URL
echo -e "[Server]\nIP=\nDOMAIN=\nDIRECTIVES_ENDPOINT=\nSERVER_ROOM=\nDIRECTIVES_FILE_URL=$DIRECTIVES_FILE_URL\n" > "$TMP_SERVER_CONFIG"

## Select the device we want to install huronOS to
print_step "[3/10] Selecting removable device to install huronOS on"
DEVICES=$(lsblk --pairs --output NAME,PATH,HOTPLUG,TYPE,VENDOR,MODEL,SIZE,LABEL --sort NAME)
COPY_DEVICES="$DEVICES"
DEVNUM=0
echo "Disks compatible with huronOS installation"
while read -r NAME DEV HOTPLUG TYPE VENDOR MODEL SIZE LABEL; do
	## Replace PATH with DEV to avoid replacing the bash-path
	DEV="$(echo $DEV | sed 's/PATH/DEV/g')"

	## The vars contain a literal declaration (eg. 'TYPE="disk"')
	## by declaring them, we make their value usable
	declare "${NAME}"
	declare "${DEV}"
	declare "${HOTPLUG}"
	declare "${TYPE}"
	declare "${VENDOR}"
	declare "${MODEL}"
	declare "${SIZE}"
	declare "${LABEL}"
	#echo -e "$NAME $DEV $HOTPLUG $TYPE $VENDOR $MODEL $SIZE $LABEL"

	## Mark disks as green, partitions indented on disk
	if [ "$HOTPLUG" = "1" ] && [ "$TYPE" = "disk" ]; then
		echo -e "\t$(tput setab 2)$(tput setaf 1)$(tput bold)$TYPE $DEVNUM  $DEV  $SIZE  $VENDOR  $MODEL $(tput sgr0)"
		DEVNUM=$((DEVNUM+1))
	elif [ "$HOTPLUG" = "1" ] && [ "$TYPE" = "part" ]; then
		echo -e "\t    $NAME $TYPE $SIZE  $LABEL"
	fi
done < <(echo "$COPY_DEVICES" | xargs -n 8)


## Ask the user the number of the selected disk
read -r -p "Please, select the disk where you want to install huronOS on:" SELECTION
COPY_DEVICES="$DEVICES"
DEVNUM=0
while read -r NAME DEV HOTPLUG TYPE VENDOR MODEL SIZE LABEL; do
	DEV="$(echo $DEV | sed 's/PATH/DEV/g')"
	declare "${NAME}"
	declare "${DEV}"
	declare "${HOTPLUG}"
	declare "${TYPE}"
	declare "${VENDOR}"
	declare "${MODEL}"
	declare "${SIZE}"
	declare "${LABEL}"
	if [ "$HOTPLUG" = "1" ] && [ "$TYPE" = "disk" ]; then
		if [ $DEVNUM -eq $SELECTION ]; then
			TARGET="$DEV"
		fi
		DEVNUM=$((DEVNUM+1))
	fi
done < <(echo "$COPY_DEVICES" | xargs -n 8)
read -r -p "The selected disk is $(tput setab 2)$(tput setaf 1)$(tput bold)$TARGET$(tput sgr0), $(tput bold)ALL DATA WILL BE LOST (includes partitions) $(tput sgr0), do you want to continue? (Y/n) " CONFIRM

## Exit if answer is not Y or y
if [ "$CONFIRM" != "Y" ] && [ "$CONFIRM" != "y" ]; then
	print_step "Exiting installer"
	exit 1
fi

## User confirmed, continue

## For each mountpoint that the device is using, kill and unmount
print_step "[4/10] Unmounting selected device partitions"
for MNT_PNT in $(lsblk --output PATH,MOUNTPOINT | grep -E "${TARGET}[1-9]+" | awk '{ print $2 }'); do
	echo "Cleaning $MNT_PNT"
	fuser -k -m "$MNT_PNT" || true
	umount "$MNT_PNT"
done

print_step "[5/10] Partitioning device $TARGET"
## Set positions on the target device
DISK_SIZE=$(blockdev --getsize64 "$TARGET")
DISK_SECTORS=$(blockdev --getsz "$TARGET")
DISK_SIZE_MB=$(( $DISK_SIZE / 1024 / 1024 )) #Convert disk size to MiB
SYSTEM_PART_END=$(( 5*1024 )) #Set 5GiB to store huronOS
EVENT_PART_END=$(( ( ($DISK_SIZE_MB - $SYSTEM_PART_END) / 2) + SYSTEM_PART_END ))

## Clean possible partition tables, asuming 512 block size dev (hope there's no 1ZiB usbs soon)
dd bs=512 if=/dev/zero of="$TARGET" count=34
dd bs=512 if=/dev/zero of="$TARGET" count=34 seek=$(( $DISK_SECTORS-34 ))

## Do de partioning
# 0% = minimal start alignment between sector size vs optimal I/O speed
# 100% = maximal end alignment
# part1 = system partition aka. huronOS partition
# part2 = event-persistence partition
# part3 = contest-persistence partition
parted -a optimal --script "$TARGET" \
	unit MiB \
	mklabel msdos \
	mkpart primary 0% $SYSTEM_PART_END \
	mkpart primary $SYSTEM_PART_END $EVENT_PART_END \
	mkpart primary $EVENT_PART_END 100% \
	set 1 boot on

## Create the filesystems
print_step "[6/10] Creating filesystems"
mkfs.vfat -F 32 -n HURONOS -I "${TARGET}1"
mkfs.ext4 -L event-data -F "${TARGET}2"
mkfs.ext4 -L contest-data -F "${TARGET}3"

## Get the UUIDs
SYSTEM_UUID=$(blkid -o value -s UUID "${TARGET}1")
EVENT_UUID=$(blkid -o value -s UUID "${TARGET}2")
CONTEST_UUID=$(blkid -o value -s UUID "${TARGET}3")
echo "system.uuid=$SYSTEM_UUID"
echo "event.uuid=$EVENT_UUID"
echo "contest.uuid=$CONTEST_UUID"

## Mount filesystems
SYSTEM_MNT=/tmp/$$/SYS
mkdir -p $SYSTEM_MNT
mount UUID=$SYSTEM_UUID $SYSTEM_MNT

## Start copying the contents of huronOS installation
print_step "[7/10] Copying huronOS system data"
cp --verbose -rf "$ISO_DIR/huronOS/" "$SYSTEM_MNT"
cp --verbose -rf "$ISO_DIR/boot/" "$SYSTEM_MNT"
cp --verbose -rf "$ISO_DIR/EFI/" "$SYSTEM_MNT"
cp --verbose -rf "$ISO_DIR/checksums" "$SYSTEM_MNT"
cp --verbose -rf "$TMP_SERVER_CONFIG" "$SYSTEM_MNT/huronOS/data/configs/sync-server.conf"


print_step "[8/10] Cleaning device buffers"
sync &
SYNC_PID=$!
while ps -p $SYNC_PID > /dev/null 2>&1; do
	echo -ne "\rRemaining data -> $(grep -e "Dirty:" /proc/meminfo)\t$(grep -i "Writeback:" /proc/meminfo)"
	sleep 1
done
echo

## Verify file checksums
print_step "[9/11] Validating installation files"
CURRENT_PATH="$(pwd)"
cd "$SYSTEM_MNT" || exit 1 # error
if ! sha256sum --check "./checksums"; then
	echo "Error ocurred, installed files are corrupt. Please retry."
	umount $SYSTEM_MNT
	rm -rf /tmp/$$/
	cd "$CURRENT_PATH" || exit 1 # erro
	exit 1
fi
cd "$CURRENT_PATH" || exit 1 # error


## Configure the bootloader
print_step "[10/11] Making device bootable"
sed "s|system.uuid=UUID|system.uuid=$SYSTEM_UUID|g" -i "$SYSTEM_MNT/boot/huronos.cfg"
sed "s|event.uuid=UUID|event.uuid=$EVENT_UUID|g" -i "$SYSTEM_MNT/boot/huronos.cfg"
sed "s|contest.uuid=UUID|contest.uuid=$CONTEST_UUID|g" -i "$SYSTEM_MNT/boot/huronos.cfg"
dd if=boot/mbr.bin of="$TARGET" bs=440 count=1 conv=notrunc 2>/dev/null
$SYSTEM_MNT/boot/extlinux.x64 --install $SYSTEM_MNT/boot/

## TODO: Configure root password and other things

## Unmount fylesystems
print_step "[11/11] Unmounting device"
umount $SYSTEM_MNT
rm -rf /tmp/$$/

print_step "Done!, you can remove your device now :)"
