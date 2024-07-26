#!/bin/bash
set -xe
mapfile -t DKMS_DEPS < dkms-deps.txt
mapfile -t NVIDIA_DEPS < nvidia-deps.txt
DEB_NAME="nvidia-kernel-dkms_525.105.17-1_amd64"
#@DEB_NAME="nvidia-kernel-dkms_470.182.03-1_amd64"
OG_DEB="$DEB_NAME.deb"
PATCHED_DEB="$DEB_NAME-patched.deb"
LAB_FOLDER="/tmp/deb-lab-$$"
EXTRACTED_DEB="$LAB_FOLDER/tmp-deb"
mkdir -p "$LAB_FOLDER"
cd "$LAB_FOLDER"
########################
#### Prepare nvidia-DKMS
#### INSTALLING AND REMOVING DEPENDENCY
########################
apt download nvidia-kernel-dkms
mkdir -p "$EXTRACTED_DEB"
dpkg-deb -R "$OG_DEB" "$EXTRACTED_DEB"
## Disable autoremove of dkms module on package removal
echo '#!/bin/bash' > "$EXTRACTED_DEB/DEBIAN/prerm"
# Remove dependency on dkms
sed -i 's|, dkms (>= 3.0.3-4~)||' "$EXTRACTED_DEB/DEBIAN/control"
## Repack patched deb
dpkg-deb -b "$EXTRACTED_DEB" "$PATCHED_DEB"
#rm -r "$LAB_FOLDER"
#rm "$DEB_NAME.deb"

######################
#### Install dkms deps
######################
apt install --yes --no-install-recommends "${DKMS_DEPS[@]}" pahole
########################
#### Install nvidia deps
########################
apt install --yes --no-install-recommends "./$DEB_NAME-patched.deb" "${NVIDIA_DEPS[@]}"
#rm "$DEB_NAME-patched.deb"

######################
#### Remove dkms deps
######################
apt remove --yes "${DKMS_DEPS[@]}" pahole nvidia-kernel-dkms
apt autoremove --yes

# savechanges /run/initramfs/memory/system/huronOS/base/02-firmware-nvidia.hsl
