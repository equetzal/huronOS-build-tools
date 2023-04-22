# Accessing the root user

**-> Default `root` password is `toor`**

By default, the *contestant* user has no password, it is logged automatically on boot and it is the user designed for any contestant during any contest or event. But in certain cases it's necessary to access the root user to solve certain issues.

**Warning:**

> The current huronOS installer is not able to setup the root password of the installed system.  
> This is a known issue and there is work in progress around this, but currently there's lack of time for developing this as this feature will require major changes involving the installer.

### Changing the root password

**TL;DR**  
Boot on demo mode or another non-persistent boot mode, change the password with `passwd`, create a directory to act as a fake root. Do `mkdir -p etc/` on the fake root, copy the shadow file as `cp /etc/shadow* etc/`, utilize the `dir2hsm` to convert the fake root into a `.hsm` module. Rename your file to the syntax of `06-$NAME.hsl` where *$NAME* is your custom name. Copy the file into `/run/initramfs/memory/system/huronOS/base/` or copy it into the USB drive on `huronOS/base/`. Reboot.

#### Context

huronOS is build in *layers* which are immutable, so, to provide persistence it stack file system layers with some of them being writable, allowing the user to preserve their changes. This is by design, so that the instances of huronOS can be remotely cleaned without needing to perform the cleaning manually.

This behavior is usually a benefit, but it come with some problems for customizing huronOS. As the system layers are immutable, commit changes to the system requires creating a system layer and stacking it at the top of the other system layers so that each time the system is booted, those changes are visible on the final system.

If you have questions on how the system layers work, please read about *Union File Systems*.

#### How to change the root password

1.  Boot the system on *demo* mode (By selecting this on the boot menu).

2.  The system passwords are stored in a specific file called [`shadow`](https://en.wikipedia.org/wiki/Passwd#Shadow*file), this file can be modified by using the `passwd` command. So, log into the root user, and execute `passwd` to change the current password.

3.  Now, this change is volatile and will be lost on reboot. We need to pack this change into a system layer. There's two methods for doing this:

    1.  Utilizing the `savechanges` utility, you can save all the deltas of the system from the `04-shared-libs.hsl` to your current state. This will include the `/etc/shadow` and `/etc/shadow-` file.
        Notice that when using this approach you'll also pack any other change in your system which can include wifi or ethernet authentications, installed apps with *apt*, preferences on the browser, or any file created since you booted the system. To take this approach do:
        ```bash
        savechanges 06-custom.hsl
        cp 06-custom.hsl /run/initramfs/memory/system/huronOS/base/
        ```

    2.  The second approach ensures you **only** include the `/etc/shadow` and`/etc/shadow-` files on the system layer. For this approach we will use the `dir2hsm` utility that is able to compress certain directory into a [*squashfs*](https://en.wikipedia.org/wiki/SquashFS) file.  
		So we first need to create a fake root directory:
        ```bash
		mkdir 06-custom.hsm
		```
		It is important that this directory starts it's name with 06 or a bigger number to ensure all the system layers are stacked in the right order. It's also important to end with the `.hsm` extension as this is needed to convert it into a *squashfs* compressed file.  
		After this, run:
		```bash
		mkdir -p 06-custom/etc
		cp /etc/shadow 06-custom.hsm/etc/
		cp /etc/shadow- 06-custom.hsm/etc/
		dir2hsm 06-custom.hsm
		mv 06-custom.hsm 06-custom.hsl
		cp 06-custom.hsl /run/initramfs/memory
		system/huronOS/base/
		```
	If you will be changing this same password on more huronOS instances, please backup your`06-custom.hsl`

4.  Reboot to see your changes applied. Now you can use huronOS as would regularly do.

#### Replicating password change on multiple huronOS instances

To replicate this change on multiple huronOS instances, you'll be needing a working `06-custom.hsl` file already created and include it on the `huronOS/base/` directory of the system partition.

1. **Case: Already have huronOS installed on multiple USBs**  
	If you already have huronOS installed and you're only looking to change the password on all of them, the easier way to do this is by copying the `06-custom.hsm` directly on the drive `huronOS/base/` directory. Depending on how many instances you want to modify, you might want to disable your automount utility and run this line each time you connect a USB:

	```bash
	mkdir -p /media/usb
	## Repeat the following and replace with the right sdX device:
	# Connect USB drive
	mount /dev/sdb1 /media/usb && cp -f 06-custom.hsm /media/usb/huronOS/base/ && umount /media/usb
	# Disconnect the USB drive
	```
2. **Case: I will be installing huronOS in multiple USBs**  
	In this case you'll highly likely want to create a custom ISO, please read the [customizing huronOS iso](./customizing-huronOS-iso.md) documentation.
