---
sidebar_position: 5
---
# Tips for Developing huronOS
So, if you plan on contributing constantly to this project, or you decide to fork it and continue on your own, these tips can help you iterate quicker on your development process. Let's check some of those tips:

- **Use two computers**  
	Developing huronOS will require to do things at different stages of the build, this can include using the build when no firmware is available, connect to the internet with only CLI, use a light editor like *nano*, or sometimes work with a UI, etc. All this environment changes can lead to unstable situations that makes it difficult to have an ideal development environment.  
	Using two computers will help in many ways. You can have a full setup for your development environment, where you'll be able to *ssh*, *lint*, *git* and take care of the commits, in one of your stations, while the other one can be used to test changes, creating builds, unit testing, scripting or package building.

- **Use two partitions, OS and Backups**  
	huronOS is built on top of Debian, so it might be necessary to install Debian several times, which can be exhausting. To prevent this, you can create 2 partitions on your disk, one for storing the *Debian* installation, and another one for backups.  
	- *Debian Partition:* For Debian, we recommend around 30GiB up to 40GiB of space. This can be an MBR partition with Legacy Boot, or GPT with UEFI, in which case you might need to also create an extra EFI partition.
	- *Backups Partition:* This can be any filesystem that supports files of the size of your partition, e.g. *40GiB*. In this backup partition you will be imaging your partition with Debian to then restore it to an ideal state.  
		You can backup the Debian partition as follows:  
		```bash
		dd if=/dev/sdX1 of=./debian-fresh-installation.img bs=4M conv=noerror,sync status=progress
		```
		And do the opposite to restore it:
		```bash
		dd if=./debian-fresh-installation.img of=/dev/sdX1 bs=4M conv=noerror,sync status=progress
		```
		For all this, suppose that `/dev/sdX1` is the device of your Debian partition.

	Which backups should I do?  
	Well, that's up to you, but here are some ideas:  
	- Just after installing Debian
	- After having successfully compiled the Kernel when all the compilation data (and cache) is still in the filesystem.  
	- After installing all the software listed on `prepare.sh` and installing the AUFS kernel with the AUFS-tools. But, before executing the actual `base.sh` or `prepare.sh` to ensure you have a ready-to-go but clean installation.


- **Use the rootcopy hack**  
	When you set the `developer` flag on the [base-system/config](../../base-system/config) file to *True*, you enable a feature called *rootcopy*.  
	Rootcopy is a feature that enables you to set a fake-root directory on your installation device. Specifically on the directory `huronOS/rootcopy` at your USB with huronOS installed.
	This means your rootcopy will be copied at the top of your stacked system layers:
	```txt
	rootcopy
	05-custom.hsl
	04-shared-libs.hsl
	03-budgie.hsl
	02-firmware.hsl
	01-base.hsl
	```
	This allows you to override specific versions of certain files and persist over reboot. For example, if you want to test a new behavior on the `hos-wallpaper` utility, you can write the new version at `huronOS/rootcopy/usr/sbin/hos-wallpaper` and this will make your copied version available as `/usr/sbin/hos-wallpaper`.  
	This can help you to quickly iterate in your development process to avoid the need to create builds to integrate all your changes.

	> **Warning:**  Please, make sure to deactivate this feature flag when creating a non-development build, as this can be used by advanced users to change the behavior of the system, letting them override almost any configuration or file including the root password.



- **Switch between persistence and non-persistence boot**
	Sometimes you want to test changes that persist, but other times you will need to test without worries and reset everything on reboot.  
	Learning when to use each of them can help you improve your development performance. Combined with the *rootcopy* feature, this can help you save your progress before rebooting and make sure you're using the right script.  
	**Example:** Let's suppose you want to create a new [software module](../../software-modules/), but it requires certain special installation. You probably want to boot without persistence, and start trying different approaches to automate this module creation. You can only write your script to the rootcopy once you have found a script that seems to work. Then you can reboot and run your script, and verify your result afterwards so you can make your adjustments. Finally, save your script and commit it.


- **Use ethernet instead of wifi**
	WiFi is super practical, and luckily the `savechanges` script used to create the system layers will always skip your network configurations, so you can securely write your Wifi password and be sure it won't be included in any module or system layer. However, setting up your WiFi each time you boot can be exhausting when developing for huronOS.  
	To tackle that, you can:  
	1. Use an Open WiFi Network:  
		Open WiFi can make the connection process way easier, although this is not the same case when you are on CLI, or when you don't have the firmware for you network card loaded *ha ha ha*. In any case, this can help you move faster but you could still consider Ethernet connection.
	2. Use ethernet:  
		Ethernet is good for huronOS development because of many reasons. You get a higher speed than Wifi, while you also get authenticated automatically, with DHCP enabled and you don't even need to touch any config. Ethernet drivers are generic and almost any computer is covered for this, even with the most basics kernels! Having an Ethernet can save you tons of time, you just reboot and you're ready, you have internet again, in CLI, in GUI, with or without firmware.