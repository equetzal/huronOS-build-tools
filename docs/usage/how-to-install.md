---
sidebar_position: 1
---
# How to Install huronOS

**Warnings:**

> huronOS is still in a _Work in Progress_ state, and many of the features that are usually expected from the installer of a distribution are not currently available.

> Currently, the huronOS installer only works on GNU / Linux distributions. It has not been tested on other _Unix-Like_ operating systems like _macOS_, _BSD_ nor utilities like _WSL_.

> **Currently, it is not possible to burn the ISO image directly into the USB** and have a working instance of huronOS due to unique features of the system that require a special installation method.

> **Currently, huronOS is not capable of working without a _directives_ file.** This file needs to live in the network and be accessible using the _http_ or _https_ URL schemes.

### Requirements

- A working GNU / Linux distro to install the system from.
- A USB device to install the system on (You will lose all your data so back it up).
- Installed dependencies *(see dependencies for your distribution)*. 
- A directives file accessible from the network that will be using huronOS. Please check the [directives file documentation](./directives/creating-a-directives-file.md) for guidance on setting up this file.

#### Dependencies
- **On Debian:**  
   ```bash
   apt install squashfs-tools parted psmisc e2fsprogs dosfstools perl-base
   ```
- **On Ubuntu:**  
   ```bash
   apt install squashfs-tools parted psmisc e2fsprogs dosfstools perl-base
   ```
- **On Fedora:**  
   ```bash
   dnf install squashfs-tools parted psmisc e2fsprogs dosfstools perl-base
   ```
- **On Arch Linux:**  
   ```bash
   pacman -S install squashfs-tools parted psmisc e2fsprogs dosfstools perl
   ```

### Process

1. **Get huronOS' ISO.**  
   You can either build the ISO by yourself or download it from the [huronOS mirrors](https://mirrors.huronos.org).  
   In this case, we will suppose that we've already downloaded the ISO file `huronOS-b2023.b0023-amd64.iso`

2. **Mount the ISO.**  
   Create a directory where you will access the contents of the ISO, for example `/media/iso`.  
   Mount the ISO on this directory:

   ```bash
   mount ./huronOS-b2023.b0023-amd64.iso /media/iso
   ```

3. **Prepare your system for the installation.**  
   Go to your ISO mounted directory, and you will find a directory structure like this:

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

   **Mask** your current automount tool. The installer will partition your USB, so automounter utilities can interfere with the installer. Please mask your automounter tool while using the installer. Eg. `systemctl mask udisks2`

4. **Upload your directives file**  
   huronOS requires a directives file to sync with, so upload your file to a server that makes it accessible to huronOS. This can be on the internet, on your intranet, on your local area network, on your own hosting server or even on github _(by accessing raw contents)_.

   > **Note:** This URL will need the creation of an exception on huronOS' firewall to the IP address of the server which is hosting this file. Not doing so would result in a soft-lock of the system, thus not being able to sync anymore.

   Please, test the access to this file **from** the network in which you will be using huronOS. Some WANs might have an external firewall blocking the access to your file, resulting in huronOS not being able to keep synchronizing.

5. **Install huronOS.**  

   1. You'll need a **16GiB+** USB drive, at least, for better performance. Please connect this USB drive; and be aware: **you will lose all data on it, for the installation**.

   2. Execute the installer, chose one of this options:
      - **Set a custom root password**  
         ```bash
         # `my_password` is your chosen password.
         ./install.sh --root-password my_password
         ```
      - **Use the default *toor* password for root**
         ```bash
         ./install.sh
         ```

   3. Fill the prompts:  
      1. Write the **directives url** to sync with, please **paste the URL you previously set up**. If you don't have one, just leave it blank _(be aware that sync won't work)_, this can be changed after the installation.
      2. Write the **directives server IP** to force the firewall exception to this specific server. You can leave it blank if you want to fallback to DNS resolution.
   4. The installer will prompt you to select a disk to target the installation. **Please do this carefully as the selected disk will be completely erased**.
   5. Wait for the installer to finish and disconnect the USB drive. If something fails during the installation process, please retry.

6. **Boot from huronOS.**  
   Connect your USB drive and boot from it. You will be auto-logged on the contestant user. To access the [root user](./root-access.md), please check the documentation.

   > **Note:** Booting will require enabling boot from USB devices. On UEFI boot, Secure Boot needs to be **disabled**.

   > **Note:** If the computer has Windows installed, make sure to fully shutdown the computer as the _Windows Fast Startup_ can prevent the computer from booting on other disks.

7. **Select the boot option.**  
   By default, huronOS will boot automatically on the `Start contest system` option after 7 seconds. Most of the times, this is what you want to use. Please refer to the [boot options](./boot-options.md) documentation for guidance on all the boot options.

**Wohoo!, You have now installed huronOS!**  
We know, there's a lot of stuff to be improved, but you can help improving this project by contributing! Try the system, use it on your own community, organize your own contests. You will find out how much time huronOS can save you to setup competitive programming competitions. Then, if you find this distro to help your community, contribute to it!, It's best for all to focus our efforts in one big definitive solution for the environment of our contests rather than creating lot of small solutions!

**Thank you :)**
