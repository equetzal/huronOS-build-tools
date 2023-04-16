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

## Variables
export INSTALLER_LAB="/tmp/huronOS-install-$$"
export SYSTEM_MNT="$INSTALLER_LAB/usb-syspart"
export SERVER_CONFIG="$INSTALLER_LAB/sync-server.conf"
export ISO_DIR=""
export DIRECTIVES_FILE_URL=""
# Argument handling
# Supports --root-password & help displaying
NEW_PASSWORD=""
while [ "$#" -gt 0 ]; do
	case "$1" in
		--root-password)
			if [ -n "$2" ]; then
				NEW_PASSWORD="$2"
				shift 2
			else
				echo "Error: option --root-password requires an argument" >&2
				exit 1
			fi
		;;
		-h|--help)
			echo "Installs the current huronOS into an usb"
			echo "Usage: ./install.sh [--root-password password]"
			exit 1
		;;
		#   Whichever other parameter passed, we know nothing about that here
		*)
			shift
		;;
  esac
done

# $1 = message to print
BOLD="$(tput bold)"
BOLD_GREEN="$(tput setab 2)$(tput bold)"
BOLD_RED="$(tput setab 2)$(tput setaf 1)$(tput bold)"
NORMAL_TEXT="$(tput sgr0)"
print_bold(){
	echo -e "${BOLD}$1${NORMAL_TEXT}"
}
print_bold_red(){
	echo -e "${BOLD_RED}$1${NORMAL_TEXT}"
}
print_step(){
	echo -e "${BOLD_GREEN}$1${NORMAL_TEXT}"
}

print_step "Starting huronOS installation"
mkdir -p "$INSTALLER_LAB"

## Save the directory where the script is running, it should match the ISO of huronOS
ISO_DIR="$(dirname "$(readlink -f "$0")")"
print_step "[1/11] Locating huronOS image -> $ISO_DIR"

## Configure the remote directives file
print_step "[2/11] Configuring directives server."
read -r -p "URL (http/s) of directives file to configure:" DIRECTIVES_FILE_URL
echo -e "[Server]\nIP=\nDOMAIN=\nDIRECTIVES_ENDPOINT=\nSERVER_ROOM=\nDIRECTIVES_FILE_URL=$DIRECTIVES_FILE_URL\n" > "$SERVER_CONFIG"

## Select the device we want to install huronOS to
# print_step "[3/11] Selecting removable device to install huronOS on"
DEV_PATHS=$(lsblk --nodeps --noheadings --raw -o PATH)
# Array to store the usb devices found
HOTPLUG_DEVICES=()
DEVNUM=0
for DEV_PATH in $DEV_PATHS; do
    # Get device attributes
    DEV_HOTPLUG="$(lsblk --nodeps --noheadings --raw -o HOTPLUG "$DEV_PATH")"
    DEV_TYPE="$(lsblk --nodeps --noheadings --raw -o TYPE "$DEV_PATH")"
    DEV_VENDOR="$(lsblk --nodeps --noheadings --raw -o VENDOR "$DEV_PATH")"
    DEV_MODEL="$(lsblk --nodeps --noheadings --raw -o MODEL "$DEV_PATH")"
    DEV_SIZE="$(lsblk --nodeps --noheadings --raw -o SIZE "$DEV_PATH")"

    # USBs surely are hotplug and disks, so we'll focus on those
    if [ "$DEV_HOTPLUG" = "1" ] && [ "$DEV_TYPE" = "disk" ];then
        # Append device to the hotplug array
        HOTPLUG_DEVICES+=("$DEV_PATH")

	    print_bold_red "$DEV_TYPE $DEVNUM  $DEV_PATH  $DEV_SIZE  $DEV_VENDOR  $DEV_MODEL"
        # Get device's available paths (includes the device itself and its partitions)
        PARTITIONS=$(lsblk --noheadings --raw -o PATH "$DEV_PATH")
        for PARTITION in $PARTITIONS; do
            # Ignore the device itself
            if [ "$PARTITION" != "$DEV_PATH" ]; then
                # Get partition attributes
                PART_NAME="$(lsblk --nodeps --noheadings --raw -o NAME "$PARTITION")"
                PART_TYPE="$(lsblk --nodeps --noheadings --raw -o TYPE "$PARTITION")"
                PART_SIZE="$(lsblk --nodeps --noheadings --raw -o SIZE "$PARTITION")"
                PART_LABEL="$(lsblk --nodeps --noheadings --raw -o LABEL "$PARTITION")"
                echo -e "\t$PART_NAME $PART_TYPE $PART_SIZE $PART_LABEL"
            fi
        done
		DEVNUM=$((DEVNUM+1))
	fi
done

# Safety check if no hotplug+disk device was found
if [ "${#HOTPLUG_DEVICES[@]}" == "0" ]; then
    echo "No usb plugged was found"
    exit 1
fi

read -r -p "Please, select the disk where you want to install huronOS on: " SELECTION

# Get the target from the array of candidate devices
TARGET=${HOTPLUG_DEVICES[$SELECTION]}
read -r -p "The selected disk is $(print_bold_red "$TARGET"), $(print_bold "ALL DATA WILL BE LOST (includes partitions)"), do you want to continue? (Y/n) " CONFIRM

## Exit if answer is not Y or y
if [ "$CONFIRM" != "Y" ] && [ "$CONFIRM" != "y" ]; then
	print_step "Exiting installer"
	exit 1
fi

## User confirmed, continue

## For each mountpoint that the device is using, kill and unmount
print_step "[4/11] Unmounting selected device partitions"
# Count every target device's mounted partitions
PARTITION_COUNT=$(mount | grep "$TARGET" | awk '{print $3}' | wc -l)

# If mounted partitions exists, unmount them.
if [[ "${PARTITION_COUNT}" -gt 0 ]]; then
  echo "Unmounting $PARTITION_COUNT partition(s)"
  PARTITIONS="$(mount | grep "$TARGET" | awk '{print $3}')"
  for PARTIITON in ${PARTITIONS}; do
    echo "Unmounting '$PARTIITON'"
    # Kill proceses interacting with the partition, if any
    fuser -k -m "$PARTIITON" || true
    # Unmount the partition
    umount "$PARTIITON" || exit 1 #Error unmounting
  done
  echo "Partition(s) unmounted correctly"
else
  echo "No partitions to unmount"
fi

# Wipes device's filesystem
wipefs -a "$TARGET" || exit 1
echo "Device cleaned out succesfully"

print_step "[5/11] Partitioning device $TARGET"
## Set positions on the target device
DISK_SIZE=$(blockdev --getsize64 "$TARGET")
DISK_SECTORS=$(blockdev --getsz "$TARGET")
DISK_SIZE_MB=$(( $DISK_SIZE / 1024 / 1024 )) #Convert disk size to MiB
SYSTEM_PART_END=$(( 6*1024 )) #Set 6GiB to store huronOS
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
print_step "[6/11] Creating filesystems"
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
mkdir -p $SYSTEM_MNT
mount UUID=$SYSTEM_UUID $SYSTEM_MNT

## Start copying the contents of huronOS installation
print_step "[7/11] Copying huronOS system data"
cp --verbose -rf "$ISO_DIR/huronOS/" "$SYSTEM_MNT"
cp --verbose -rf "$ISO_DIR/boot/" "$SYSTEM_MNT"
cp --verbose -rf "$ISO_DIR/EFI/" "$SYSTEM_MNT"
cp --verbose -rf "$ISO_DIR/checksums" "$SYSTEM_MNT"
cp --verbose -rf "$SERVER_CONFIG" "$SYSTEM_MNT/huronOS/data/configs/sync-server.conf"

# If a password was passed, update the password
if [ -n "$NEW_PASSWORD" ]; then
  print_step "[7.5/11] Setting new password: $NEW_PASSWORD"
  utils/change-password.sh "$NEW_PASSWORD" "$SYSTEM_MNT" || exit 1
fi

print_step "[8/11] Cleaning device buffers"
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
umount $SYSTEM_MNT && rm -rf "$INSTALLER_LAB"

# Show the password used in this instalation
if [ -n "$NEW_PASSWORD" ]; then
  print_step "The root password was set to: $NEW_PASSWORD"
else
  print_step "The root password is the default one (toor, unless you executed ./change-password)"
fi

print_step "Done!, you can remove your device now :)"
