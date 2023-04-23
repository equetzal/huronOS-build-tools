---
sidebar_position: 3
---
# Tips for Developing huronOS
So, if you plan to contribute continuously to this project, or you decide to fork it and continue by your own, this tips can help you to iterate quicker on your development process. Let's check some of those tips:

- **Use two computers**  
	Developing huronOS will require to do things at different stages of the build, this can include using the build when no firmware is available, connect to the internet with only CLI, use a light editor like *nano*, or sometimes work with a UI, etc. All this environment change can lead to uncertain situations, so having a development environment can be really difficult on this situations.  
	Using two computers will help in many ways. In one you can have a full setup of your development environment, where able to *ssh*, *lint*, *git* and take care of the commits. The other one, can be used to test all this changes, by doing builds, test components, scripts or packing.

- **Use two partitions, OS and Backups**  
	huronOS is built on top of debian, so it might be necessary to install debian several times, and this can be exhausting. To avoid this, you can create 2 partitions on your disk, one for storing the *Debian* installation, and other one for backing up this same.  
	- *Debian Partition:* For Debian, we recommend you around 30GiB up to 40GiB. This can be a MBR partition with Legacy Boot, or GPT with UEFI, in which case you might need to also create an extra EFI partition.
	- *Backups Partition:* This can be any file system that supports files of the size of your partition, e.g. *40GiB*. In this backup partition you will be imaging your partition with debian to then restore it an ideal state.  
		You can backup the debian partition as de following:  
		```bash
		dd if=/dev/sdX1 of=./debian-fresh-installation.img bs=4M conv=noerror,sync status=progress
		```
		And do the opposite to restore this state:
		```bash
		dd if=./debian-fresh-installation.img of=/dev/sdX1 bs=4M conv=noerror,sync status=progress
		```
		For all this, suppose that `/dev/sdX1` is the device of your debian partition.

	Which backups should I do?  
	Well, that's up to you, but here are some ideas:  
	- Just after installing Debian
	- After successfully compiled the Kernel when all the compilation data (and cache) stills on the filesystem.  
	- After installing the all the software listed on `prepare.sh` and installing the AUFS kernel with the AUFS-tools. But before executing the actual `base.sh` or `prepare.sh` to ensure you have a ready-to-go installation but clean installation.


- **Use the rootcopy hack**  
	When you set the `developer` flag on the [base-system/config](../../base-system/config) file to *True*, you enable a feature called *rootcopy*.  
	Rootcopy is a feature that enables you to set a fakeroot directory on your installation device. Specifically on the directory `huronOS/rootcopy` on your USB with huronOS installed.
	This means, that your rootcopy will be copied at the top of you stacked system layers:
	```txt
	rootcopy
	04-shared-libs.hsl
	03-budgie.hsl
	02-firmware.hsl
	01-base.hsl
	```
	This enables you to override specific versions of certain files and persist over reboot. For example, if you want to test a new behavior on the `hos-wallpaper` utility, you can write the new version on `huronOS/rootcopy/usr/sbin/hos-wallpaper` and this will make your copied version available as `/usr/sbin/hos-wallpaper`.  
	This can help you to quickly iterate on your development process to avoid needing to create builds to integrate all your changes.

	> **Warning:**  Please, make sure to deactivate this feature flag when creating a non-development build, as this can be used by advanced users to change the behavior of the distro, being able to override almost any configuration or file including the root password.



- **Switch between persistence and non-persistence boot**
	Sometimes you want to test changes that persist, but other times you will be needing to test without worries and reset everything on reboot.  
	Learning when to use them can help you to improve your performance in development. This, combined with the *rootcopy* feature, can help you to save the your progress before rebooting and be sure to use the right script.  
	**Example:** Let's suppose you want to create a new [software module](../../software-modules/), but it requires certain special installation. You probably want to boot without persistence, and start trying different approaches to automate this module creation. You can only write your script to the rootcopy once you have find a script that seems to work. Then you can reboot and run your script, then verify your result and make your adjustments. Finally save your script and commit it.


- **Use ethernet instead of wifi**
	Wifi is super practical, and luckily the `savechanges` script used to create the system layers, always skip your network configurations, so can securely write your Wifi password and be sure it won't be included in any module or system layer. But in any case, setting up your wifi each time you boot can be exhausting when developing for huronOS.  
	Because of this, you can:  
	1. Use an Open Wifi Network:  
		The Open wifi can make the connect process way easier, but this is not the same case when you are on CLI, or when you don't have the firmware for you network card loaded *ha ha ha*. In any case, this can help you move faster but consider the Ethernet.
	2. Use ethernet:  
		Ethernet is good for huronOS development because of many ways. You get a faster speed than Wifi, but you also get authenticated automatically and with DHCP enabled, you don't even need to touch any config. Ethernet drivers are generic and almost any computers is covered for this, even with the most basics kernels! Having an Ethernet can save you ton of time, you just reboot and ready, you have internet again, in CLI, in GUI, with or without firmware.