---
sidebar_position: 3
---
# Boot Options

![huronOS bootloader sample image](../assets/huronOS_bootloader_sample.png)

## Start contest system
This is the default boot option, and you will boot into it after 7 seconds if you don't press `esc` before this timer ends.
This option syncs to the **directives URL** that you setup during installation by default, this means you'll have persistence enabled as well as all the directives you just setup on the directives file.

With this option, you only need to boot and all the configurations will be prepared for you! :D
 > Note, if for any reason you need to restart the computer of a contestant  during a competition, please make sure to use this same option for boot, and give the system 1 minute for recovery time and full resync. All the data of the contest should be automatically restored.

 ## Start no-sync mode
This option will boot huronOS with the *sync manager* deactivated, meaning you won't have persistence, and no directive will be activated on the system. This option is useful for different scenarios like:
- Manually cleaning the `event/` or `contest/` partitions.
- Setting up a demo where you need to store data resilient to mode changes, e.g. casting screen to a projector.
- Developing huronOS and needing to use `savechanges` scripts.

If after booting on no-sync mode you want to start the contest system, please execute it in a **root** shell:
```bash
systemctl start hsync.timer
```