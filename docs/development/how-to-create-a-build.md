# Building huronOS

To build huronOS you'll be needing to follow several steps:

1. **Install Debian:**  
   Firstly install on a computer Debian 11.6 with a minimal installation setup. Make sure to do not install **any** extra software mentioned on the installer, and do not setup extra users other than root. (if you do, erase them)

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

   After this, a directory and two files on `/tmp` will be created: `gen_iso_image.sh`, `gen_zip_image.sh` and `*-huronOS-data/` directory. If your `/tmp` directory is volatile, please move this files to another newly created directory on `/` (e.g. `/iso`).

5. **Build the other system layers**

   To build the rest of the layers, you'll be needing to install huronOS on a temporal USB drive using the `install.sh` provided on the `*-huronOS-data/` directory.

   After this, please boot on the installed system.
   Once booted, make sure to have access to this repository and internet connection. **Please, consider that at this step, no persistence is provided yet, so all the changes will be volatile**

   Run as **root** the following commands to build the rest of the modules:

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
   - `05-password.hsl`:
     ```bash
     cd software-modules/base/05-password/
     chmod +x password.sh
     ./password.sh
     reboot
     ```

   ```
    After this, return to the debian installation and plug the USB drive, then copy the modules on the `*-data-huronOS/base/` directory.

   ```

6. **Pack the current software**

   After installing the base, the software to be used on competitions like ICPC or IOI will be required. The build scripts for each package are located in the directories

   - [`internet`](./software-modules/internet/)
   - [`langs`](./software-modules/langs/)
   - [`programming`](./software-modules/programming/)
   - [`tools`](./software-modules/tools/)

   After finishing with all the software, copy the resultant `.hsm` files to the `*-data-huronOS/huronOS/software/` directory following the structure of the tree. Remember to reboot each time you create an `.hsm` module to prevent accumulating changes.

7. **Create the ISO**

   After completing the huronOS data directory, you can run the `gen_iso_file.sh` to create the packed ISO.
