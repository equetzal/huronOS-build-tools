#!/bin/bash

#set -x

## Save the directory where the script is running, it should match the ISO of huronOS
ISO_DIR=$(dirname $(readlink -f $0))
echo "huronOS Image directory -> $ISO_DIR"

## Select the device we want to install huronOS to
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
read -p "Please, select the disk where you want to install huronOS on:" SELECTION
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
read -p "The selected disk is $(tput setab 2)$(tput setaf 1)$(tput bold)$TARGET$(tput sgr0), $(tput bold)ALL DATA WILL BE LOST (includes partitions) $(tput sgr0), do you want to continue? (Y/n) " CONFIRM

## Exit if answer is not Y or y
if [ "$CONFIRM" != "Y" ] && [ "$CONFIRM" != "y" ]; then
	exit 1
fi

## User confirmed, continue

## For each mountpoint that the device is using, kill and unmount
for MNT_PNT in $(lsblk --output PATH,MOUNTPOINT | grep -E "/dev/sdc[1-9]+" | awk '{ print $2 }'); do
	echo "Cleaning $MNT_PNT"
	fuser -k -m "$MNT_PNT" || true
	umount "$MNT_PNT"
done

## Set positions on the target device
DISK_SIZE=$(blockdev --getsize64 $TARGET)
DISK_SECTORS=$(blockdev --getsz $TARGET)
DISK_SIZE_MB=$(( $DISK_SIZE / 1024 / 1024 )) #Convert disk size to MiB
SYSTEM_PART_END=$(( 5*1024 )) #Set 5GiB to store huronOS
EVENT_PART_END=$(( ( ($DISK_SIZE_MB - $SYSTEM_PART_END) / 2) + SYSTEM_PART_END ))

## Clean possible partition tables, asuming 512 block size dev (hope there's no 1ZiB usbs soon)
dd bs=512 if=/dev/zero of=$TARGET count=34
dd bs=512 if=/dev/zero of=$TARGET count=34 seek=$(( $DISK_SECTORS-34 ))

## Do de partioning
# 0% = minimal start alignment between sector size vs optimal I/O speed
# 100% = maximal end alignment
# part1 = system partition aka. huronOS partition
# part2 = event-persistence partition
# part3 = contest-persistence partition
parted -a optimal --script $TARGET \
	unit MiB \
	mklabel msdos \
	mkpart primary 0% $SYSTEM_PART_END \
	mkpart primary $SYSTEM_PART_END $EVENT_PART_END \
	mkpart primary $EVENT_PART_END 100% \

## Create the filesystems
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

## Start copying the contents of huronOS installation

## Configure the bootloader

## Configure root password and other things
