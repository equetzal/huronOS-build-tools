---
sidebar_position: 2
---
# System Requirements

huronOS works as a live USB, so, in your requirements, you will need to consider USB sticks. Currently, we do not support virtual machines.

## USB Requirements:
- A USB of **16+ GiB**  
    *The system weights 1 GiB and ~ 4 GiB are used for ICPC and IOI's required software, the remaining space is used for persistence, so, 8 GiB will give little space for persistence. A 16+ GiB USB would be preferable. *

- Buy USB drives of **well known manufacturers**.  
    *The cheapest USB drives are usually not reliable for liveUSB systems use, in general (e.g. the ones used for tampography). Also, consider these drives will have a high level of reading and writing operations. We do recommend manufacturers like Kingstone, SanDisk or Samsung, etc.*

- Prioritize **USB C + A**  
    *If you're sure all your computers have USB type C ports, we highly recommend them for their speed and practicality; but if you're able to, it would be better to opt for a dual USB drive that shares the same memory with two interfaces, one USB type A and one type C. Using USB-A is not a disadvantage but more computers are being manufactured with USB C ports only, so keep in mind that buying dual drives can be a more flexible option.*

- Prioritize **USB 2.0+**  
    *Writing speed is more important than reading speed for huronOS; nevertheless, generally speaking, speed is not so important. We built huronOS by using the RAM as the main drive, which means that speed is always high; the most stressful moments for reading is at boot time, where the writing is performed at RAM speed and then queued for writing in the disk, which usually has a delay of 1-15 seconds, although it heavily tends to 1s. This is a good balance for persistence and speed, allowing for cheaper purchase options, like non USB 3.0+. We do not discourage the use of 3.0+, but its use is not mandatory*

## Computer Requirements:
- Network: We highly recommend wired networking with DHCP. WiFi is also supported, but we are not able to automate authentication yet.

- RAM: We recommend **at least** 8 GiB of RAM, 16+ GiB is preferred. Consider that huronOS lives on RAM and the disk is the RAM as well, which is then synched to the USB drive for persistence. Your RAM is your drive limit and it will be used for the system files + persistence + RAM + caches, and there's no swap. So, to avoid memory shortage issues, we do recommend having at least 8 GiB. With 4 GiB you'll likely run out of memory with a bad programmed DP. 

- Disk: huronOS does not use the computer's disk drive.

- Processor: We only support x86_64 processors, when more human resources are available, we might explore releasing also an x86_32 and ARM build.

- GPU: Integrated is more than enough.

### IMPORTANT:
**huronOS Queue 0.3 known issue with Nvidia Graphic Cards:** We have not identified which Nvidia GPUs are affected, but some models have a problem with the *firmware* which can lead to a system hang (freeze) that is only solved by a reboot. We have not been able to reproduce this error. Please, if you have Nvidia GPUs, don't use the system for **official** competitions. We will work hard into solving this issue, but consider it's out of the scope of the project as this is a bug in the drivers provided by the manufacturers.  
[**Check the progress of this issue on Github**](https://github.com/equetzal/huronOS-build-tools/issues/59).

