---
sidebar_position: 2
---
# System Requirements

huronOS works as a live USB, so in your requirements you will need to consider USB sticks. Currently we do not support virtual machines.

## USB Requirements:
- A USB of **16+ GiB**  
    *The system weights 1 GiB but ~ 4 GiB are used for software required by the ICPC and IOI, the rest of the space is used for persistence, so 8 GiB will give few space for persistence.*

- Buy USB drives of **well known manufacturers**.  
    *The cheapest USB drives are usually not reliable to use for liveUSB systems in general (e.g. the ones used for tampography), also consider this drives will have a high level of read and write operations. We do recommend manufacturers like Kingstone, SanDisk or Samsung, etc.*

- Prefer **USB C + A**  
    *If you're sure all your computers do have USB type C, we do highly recommend them for their speed and practicity, but if you're able to, it would be better to opt for a dual USB drive which shares the same memory with two interfaces, one USB type A and one type C. Using USB A is not a disadvantage but more computers are being manufactured only with USB C, so keep in mind that buying dual drives can improve the flexibility.*

- Prefer **USB 2.0+**  
    *Write speed is more important than readspeed for huronOS, but in general speed is no -that- important. We built huronOS by using the RAM as the main drive so that speed is always fast, the harder moments for reading is at boot time, and the write is performed at RAM speed and then queued for write in the disk, which usually have a delay of 1-15 seconds, but heavily tend to 1s. This is a good balance for persistence and speed and allowing cheaper options like non USB 3.0+. We do not discourage the use of 3.0+, but it's not required*

## Computer Requirements:
- Network: We do highly recommend cabled network with DHCP. Wifi is also supported, but we cannot automate auth yet.

- RAM: We do recommend **at least** 8 GiB of RAM, 16+ GiB is prefered. Consider that huronOS lives on RAM and the disk is the RAM which is then sync to the USB drive for persistence. Your RAM is your drive limit and it will be used for the system files + persistence + RAM + caches, and there's no swap. So, to avoid memory shorage issue, we do recommend having at least 8 GiB. With 4 GiB you'll likely run out of memory with a bad programmed DP. 

- Disk: huronOS does not use the disk drive of the computer.

- Processor: We do only support x86_64 processors, when more human time is available, we might explore releasing also a x86_32 and ARM build. 

- GPU: Integrated is more than enough.

### IMPORTANT:
**huronOS Queue 0.3 known issue with Nvidia Graphic Cards:** We have not identified which Nvidia GPUs are affected, but some models have a problem with the *firmware* which can lead to a system hang (freeze) that is only solved by reboot. We have not been able to reproduce this error. Please if you have a Nvidia GPUs don't use the system for **official** competitions. We will work hard into solving this issue, but take into account that it's out of the scope of the project as this is a bug in drivers provided by manufacturers.  
[**Check the progress of this issue on Github**](https://github.com/equetzal/huronOS-build-tools/issues/59).

