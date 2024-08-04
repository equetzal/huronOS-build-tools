building-manually


# TODO: Talk about manually building the OS layers and software layers




5. **Build the other system layers**

   To build the rest of the layers, 

   

   Run, as **root**, the following commands to build the rest of the modules:

   - `02-firmware.hsl`:
     ```bash
     cd software-modules/base/02-firmware/
     chmod +x firmware.sh
     ./firmware.sh
     quick-reboot
     ```
   - `03-budgie.hsl`:
     ```bash
     cd software-modules/base/03-budgie/
     chmod +x budgie.sh
     chmod +x setup-desktop.sh
     ./budgie.sh
     quick-reboot
     ```
   - `04-shared-libs.hsl`:
     ```bash
     cd software-modules/base/04-shared-libs/
     chmod +x shared-libs.sh
     ./shared-libs.sh
     quick-reboot
     ```
   - `05-custom.hsl`:
     ```bash
     cd software-modules/base/05-custom/
     chmod +x custom.sh
     ./custom.sh
     quick-reboot
     ```

   
   Next, return to the debian installation and plug the USB drive, then copy the modules on the `iso-data/huronOS/base/` directory.

6. **Pack the current software**

   After installing the base, the software to be used on competitions like ICPC or IOI will be required. The build scripts for each package are located in the directories

   - [`internet`](./software-modules/internet/)
   - [`langs`](./software-modules/langs/)
   - [`programming`](./software-modules/programming/)
   - [`tools`](./software-modules/tools/)

   After finishing with all the software, copy the resultant `.hsm` files to the `iso-data/huronOS/software/` directory following the structure of the tree. Remember to reboot each time you create an `.hsm` module to prevent accumulating changes.