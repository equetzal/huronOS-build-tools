# How to Install huronOS

**Warnings:**

> huronOS is still _Work in Progress_, and lot of the features that are usually expected from the installer of a distribution are not currently available.

> Currently, the huronOS installer does only work on GNU / Linux distros. It has not been tested on other _Unix-Like_ operating systems like _macOS_, _BSD_ or utilities like _WSL_.

> **Currently, is not possible to burn the ISO image directly on the USB** and have a working instance of huronOS due to unique features of the system that requires an special installation method.

> **Currently, huronOS is not capable of work without a _directives_ file.** This file needs to live in the network and be accessible using the _http_ or _https_ URL schemes.

### Requirements

- A working Linux distro to install the system from.
- A USB device to install the system on (You will lose all your data so back it up).
- The software for executing the commands: `bash`, `fuser`, `parted` (GNU Parted), `mkfs.vfat`, `mkfs.ext4`, `sha256sum`.
- A directives file accessible from the network that will be using huronOS. Please check the [directives file document](./creating-a-directives-file.md) for guidance on setting up this file.

### Process

1. **Get the ISO of huronOS.**  
   You can either build the ISO by yourself or download it from the [huronOS website](https://huronos.org).  
   For this case, we will supose that we've already downloaded the ISO file `huronOS-b2023.b0023-amd64.iso`

2. **Mount the ISO.**  
   Create a directory where you will access to the contents of the ISO, for example `/media/iso`.  
   Mount the ISO on this directory:

   ```bash
   mount ./huronOS-b2023.b0023-amd64.iso /media/iso
   ```

3. **Prepare your system for the installation.**  
   Go to your iso mounted directory, and you will find a directory structure like this:

   ```txt
   /media/iso/
   	├── boot
   	├── checksums
   	├── EFI
   	├── huronOS
   	├── install.sh
   	└── utils
   	   └── change-password.sh
   ```

   Make sure you can execute all the commands within `install.sh`. This is needed in order to successfully use the installer.  
   **Mask** your current automount tool. The installer will partition your USB, so automounter utilities can interfere with the installer. Please mask your automounter tool while using the installer. Eg. `systemctl mask udisks2`

4. **Upload your directives file**  
   huronOS requires a directives file to sync with, so upload your file to a server that makes it accessible to huronOS. This can be on the internet, on your intranet, on your local area network, on your own hosting server or even on github _(by accessing raw contents)_.

   > **Note:** This URL will create an exception on the firewall of huronOS to the IP address of the server which is hosting this file. Not doing this would result on a soft-lock of the system not being able to sync anymore.

   Please, test the access to this file **from** the network in which you will be using huronOS. Some WANs might have an external firewall blocking the access to your file, resulting in huronOS not being able to keep in sync.

5. **Install huronOS.**  
   Connect your USB drive, and execute the installer by running `./install.sh`.

   1. The installer will prompt you to write the _directives url_ to sync with, please paste the URL you previously setup. If you don't have one, just leave it blank _(just be aware that sync won't work)_, this can be changed after the installation.
   2. The installer will prompt you to select a disk to target the installation. **Please do this carefully as the selected disk will be completely erased**.
   3. Wait for the installer to finish and disconnect the USB drive. If something fails during the installer, please retry.

   **Note:** You can change the default root password of the current instalation by executing the installer like this
   ```
    ./install.sh --root-password my_password
   ```
   Keep in mind that if you want to change the password for every latter instalations that you might create, instead of manually passing the password each time in the installer, follow the steps mentioned below
   
   * Copy all the contents of the ISO somewhere where you have RW access, let's call this path ~/iso/
   * Navigate to ~/iso/utils
   * From there execute
      ```
      ./change-password my_password
      ```
      Be sure to change ***my_password*** with the password that you want to set as the root password
   * You're all set. Every other instalation you make will have the password you defined.
6. **Boot from huronOS.**  
   Connect your USB drive and boot from it. You will be auto-logged on the contestant user. For accessing the [root user](./root-access.md), please check the documentation.

   > **Note:** Booting will require enabling boot from USB devices. On UEFI boot, Secure Boot needs to be **disabled**.

   > **Note:** If the computer have windows installed, make sure to fully shutdown the computer as the _Windows Fast Startup_ can prevent the computer from booting on other disks.

7. **Select the boot option.**  
   By default huronOS will boot automatically on `Start contest system` option after 7 seconds. Most of times this is what you want to use. Please refer to the [boot options](./boot-options.md) documentation for guidance on all the boot options.

**Wohoo!, You have installed huronOS!**  
We know, there's a lot of stuff to be improved, but you can help this project to get improved by contributing! Try the system, use it on your own community, arrange your own contests. You will find out how much time huronOS can save you to setup competitive programming competitions. Then, if you find this distro to help your community, contribute to it!, It's better for all to focus our efforts in one big definitive solution for the environment of our contests rather than creating lot of small solutions!

**Thank you :)**
