---
sidebar_position: 8
---

# Building huronOS
huronOS is an immutable system which is built in layers and modules to provide all the functionalities it is designed for. This means that to build the system you'll firstly need to:
1. Create a base system
2. Install the base into a USB drive
3. Build the rest of the system layers
4. Build all the software modules

## Building the base system

1. **Install Debian:**  
   First, install Debian 11.6 in a computer with a minimal installation setup. Make sure to not install **any** extra software mentioned on the installer, and do not setup extra users other than root (if you do, erase them).

2. **Get huronOS-build-tools**  
   Clone this repo on the `/` root directory of your newly installed Debian with the following command
   
   ```bash
   git clone --recurse-submodules https://github.com/equetzal/huronOS-build-tools
   ```

3. **Compile the huronOS kernel**  
   huronOS needs a kernel that supports [AUFS](https://aufs.sf.net), so we need to replace the kernel. To do so, run as **root**:

   ```bash
   cd builder-scripts/kernel/
   chmod +x build-kernel.sh
   ./build-kernel.sh --build-kernel
   ```

   Then reboot your computer and run 
   ```bash
   cd builder-scripts/kernel/
   ./build-kernel.sh --clean-kernel ## To delete all the other kernels in the system
   ./build-kernel.sh --clean-packages ## To remove all the packages installed for building the kernel
   ```

   > Note: After building your kernel, you'll get a .tag.gz file with your compilation. To restore it on a system just run:
   > ```bash
   >  ./build-kernel.sh --restore-kernel
   > ```
   > *Alternatively, you can also download one of the kernel packages available at https://archive.huronos.org/builds/kernel/

4. **Build the base ISO**  
   To build the base system (`01-base.hsl`) and the huronOS bootable skeleton filesystem, run as **root**:  

   ```bash
   chmod +x base-system/base.sh
   ./base-system/base.sh
   ```

   Afterwards, you will find a similar directory on `/tmp`:
   ```bash
   huronOS-build-tools-67321/ ## Suffix of the PID
      ├── iso-data/
      └── make-iso.sh
   ```
   By default, make-iso.sh will have a field `ISO_DATA=/tmp/huronOS-build-tools-67321/iso-data` and `ISO_OUTPUT=/tmp/huronOS-build-tools-67321/huronOS-b2023.00xx-amd64.iso`. If you're planing to move the directory, please make sure to update this routes accordingly.

## Building the system layers
After you've got the base system, the huronOS toolkit should be available, but you'll need to install the base OS into a USB drive to continue with the building of the system. For this task, you have 2 options:
1. Use *`sysforge`* to automate the build process; or
2. Build each layer [manually](./building-manually.md) (Useful in case that you only want to build certain layers)

In any case, you will need to install huronOS at a temporal USB drive, so go ahead and run:
   ```bash
   ./make-iso.sh # This step is necessary as it will calculate the checksums of the files
   ./iso-data/install.sh # You just hit enter when prompt for directives URL and directives server IP
   ```
After this, please boot up the installed system with the boot option ***No-sync mode**.

1. **Setup sysforge:**  
   Sysforge is a utility that automatically queue the build scripts, wait for internet connectivity, saves the modules or system layers and reboot the system for building the next layers. In order to successfully run it, you need to:
   - Have the huronOS-build-layers available in a disk and checked out in the branch/commit you want to build the system with.
   - Have a wired internet connectivity with DHCP connected to the computer you're booting huronOS with.
   - Have the path were you want to mount the disk with the huronOS-build-tools repository.
   - Have the pull path of the mount point + the huronOS-build-tools directory.

   Example:
   ```txt
   Configuration:
   DISK_WITH_HBT="/dev/sda1"
   DISK_MOUNT_POINT="/media/disk"
   PATH_TO_HBT="/media/disk/src/huronOS-build-tools"
   ```

2. **Run sysforge:**  
   After you have this data, boot on the system and run:
   ```bash
   ## Alternatively, omit a flag if you do not desire to build the system layers or the modules
   sysforge --system-layers --software-modules
   ```

   Fill the prompts. After this, wait for the system to finish building the system. 

3. **Copy the system to the iso-data:**  
   After finishing the execution of *sysforge*, copy all the contents of huronOS/base and huronOS/software from the USB drive to the `huronOS-build-tools-67321/iso-data/` directory. Then proceed to run the `./make-iso.sh` script to create the ISO image for your system. 