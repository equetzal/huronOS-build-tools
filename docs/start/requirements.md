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
- **Network:** We highly recommend wired networking with DHCP. While WiFi is also supported, we're not able to automate authentication yet.

- **RAM:** We recommend **at least** 8 GiB of RAM, 16+ GiB is preferred. Consider that huronOS lives on RAM and the disk is the RAM as well, which is then synched to the USB drive for persistence. Your RAM is your drive limit and it will be used for the system files + persistence + RAM + caches, and there's no swap. So, to avoid memory shortage issues, we do recommend having at least 8 GiB. With 4 GiB you'll likely run out of memory with a bad programmed DP. 

- **Disk:** huronOS does not use the computer's disk drive.

- **Processor:** We only support x86_64 processors, when more human resources are available, we might explore releasing also an x86_32 and ARM build.

- **GPU:** Integrated is more than enough.

## Network Requirements
- **DHCP for IPv4**  
    DHCP can improve the setup times for contest arenas using huronOS. Currently, huronOS cannot persistently save static IP configurations, so the setup needs to be done manually each time the system is booted. This is why it is highly encouraged to use DHCP.

- **Disable IPv6**  
    huronOS is currently not capable of supporting IPv6 automated firewall setup. Due to this limitation, it is recommended to disable IPv6 on your network and use only IPv4. Having a dual IP stack for v4 and v6 can lead to IPv4 firewall not working properly, as users might have access to IPv6-allowed sites.

- **Wired Network**  
    While WiFi is supported, a wired network is always preferred over a wireless one for a more reliable and the automated setup. Additionally, wireless cards come from a variety of vendors, and the drivers might not be available with the huronOS ISO image. We strive to provide as many drivers as possible, but sometimes you will need to install them manually. With Ethernet, this isn't the case as most generic drivers work on all types of Ethernet interfaces.

- **Firewall**:  
    - **ICMP** *[all ICMP traffic]*  
        ICMP protocol is inoffensive and very useful for checking the network health status; is also useful for testing the servers with `ping` and is a good indicator that firewall is properly configured.

    - **DNS** *[Source port 53: UDP, TCP traffic]*  
        DNS is essential for web browsing and for setting up huronOS' firewall.
        > **Note:** huronOS uses Google's DNS servers (*8.8.8.8* and *8.8.4.4*) as the main DNS service and Cloudflare's DNS servers (*1.1.1.1* and *1.0.0.1*) as a backup service. This can be overridden by setting a *nameserver* when using DHCP. Please be aware of network slowness if your network-level firewall is blocking either Google DNS or Cloudflare DNS.

    - **DHCP** *[Source port 67, Dest port 68: UDP]*  
        DHCP is necessary to avoid manual configuration of the network on huronOS. It is recommended to keep these ports open even if manual setup is being performed. However, if you want to quickly set up an arena with huronOS, your setup time can be drastically reduced with DHCP.

    - **NTP** *[Source port 123: UDP]*  
        NTP is **extremely important** for huronOS, as several features rely on an accurate time and date, such as starting or finishing a contest mode. The only way to ensure all computers are in sync and none of them will start a contest at a different time is by using NTP to synchronize the date.
        > *By default, huronOS does not trust the hardware clock, so having the NTP service is essential.*

    - (Optional) **Translate API** *[Source port: 443, Source web: translate.googleapis.com]*  
        If you will be running a contest for participants with a elementary proficiency in English (which is the official language for several competitions), you might want to provide a translator (that cannot act as a proxy) to help them better understand the problems. This firewall rule is necessary for *Crow Translate* to work. Make sure to [enable this software](../usage/directives/configurations/software-modules.md) in the directives.


### IMPORTANT:
**huronOS Queue 0.3 known issue with Nvidia Graphic Cards:** We have not identified which Nvidia GPUs are affected, but some models have a problem with the *firmware* which can lead to a system hang (freeze) that is only solved by a reboot. We have not been able to reproduce this error. Please, if you have Nvidia GPUs, don't use the system for **official** competitions. We will work hard into solving this issue, but consider it's out of the scope of the project as this is a bug in the drivers provided by the manufacturers.  
[**Check the progress of this issue on Github**](https://github.com/equetzal/huronOS-build-tools/issues/59).

