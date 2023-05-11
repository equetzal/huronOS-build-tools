---
sidebar_position: 5
---
# Building huronOS

To build huronOS you'll need to follow several steps:

1. **Install Debian:**  
   First, install Debian 11.6 in a computer with a minimal installation setup. Make sure to not install **any** extra software mentioned on the installer, and do not setup extra users other than root. (if you do, erase them).

2. **Get huronOS-build-tools**  
   Clone this repo on the `/` root directory of your newly installed Debian.

3. **Compile the huronOS kernel**  
   huronOS needs a kernel that supports [AUFS](https://aufs.sf.net), so we need to replace the kernel. To do so, run as **root**:

   ```bash
   cd kernel-builder/
   chmod +x build-kernel.sh
   ./build-kernel.sh
   ```

4. **Build the base system**  
   To build the base system (`01-base.hsl`) and the huronOS bootable skeleton filesystem, run as **root**:  

   ```bash
   chmod +x base-system/base.sh
   ./base-system/base.sh
   ```

   Afterwards, you will find a similar structure to the following directory on `/tmp`:
   ```bash
   huronOS-build-tools-67321/ # Taking 67321 as an example, this will be different with each case. This value is the PID of the process.
      ├── iso-data/
      └── make-iso.sh
   ```
   By default, make-iso.sh will have a field `ISO_DATA=/tmp/huronOS-build-tools-67321/iso-data` and `ISO_OUTPUT=/tmp/huronOS-build-tools-67321/huronOS-b2023.00xx-amd64.iso`. If you're planing to move the directory, please make sure to update this routes accordingly.

5. **Build the other system layers**

   To build the rest of the layers, you'll need to install huronOS at a temporal USB drive, so go ahead and run:
   ```bash
   ./make-iso.sh # This step is necessary as it will calculate the checksums of the files
   ./iso-data/install.sh # You just hit enter when prompt for directives URL and directives server IP
   ```

   After this, please boot up the installed system.
   Once booted, make sure to have access to that repository and internet connection. **Please, consider that at this step, no persistence has been provided yet, so all the changes will be volatile**

   Run, as **root**, the following commands to build the rest of the modules:

   - `02-firmware.hsl`:
     ```bash
     cd software-modules/base/02-firmware/
     chmod +x firmware.sh
     ./firmware.sh
     reboot
     ```
   - `03-budgie.hsl`:
     ```bash
     cd software-modules/base/03-budgie/
     chmod +x budgie.sh
     chmod +x setup-desktop.sh
     chmod +x save.sh
     ./budgie.sh
     # Wait for the GUI to start
     ./setup-desktop.sh # Run this as contestant
     ./save.sh # Run this as root
     reboot
     ```
   - `04-shared-libs.hsl`:
     ```bash
     cd software-modules/base/04-shared-libs/
     chmod +x shared-libs.sh
     ./shared-libs.sh
     reboot
     ```
   - `05-custom.hsl`:
     ```bash
     cd software-modules/base/05-custom/
     chmod +x custom.sh
     ./custom.sh
     reboot
     ```

   
   Next, return to the debian installation and plug the USB drive, then copy the modules on the `iso-data/huronOS/base/` directory.

6. **Pack the current software**

   After installing the base, the software to be used on competitions like ICPC or IOI will be required. The build scripts for each package are located in the directories

   - [`internet`](./software-modules/internet/)
   - [`langs`](./software-modules/langs/)
   - [`programming`](./software-modules/programming/)
   - [`tools`](./software-modules/tools/)

   After finishing with all the software, copy the resultant `.hsm` files to the `iso-data/huronOS/software/` directory following the structure of the tree. Remember to reboot each time you create an `.hsm` module to prevent accumulating changes.

7. **Create the ISO**

   After completing the huronOS *iso-data* directory, you can run again the `make-iso.sh` to create the packed ISO and the Sha256 checksum.
