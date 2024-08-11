---
sidebar_position: 1
---
# Introduction to huronOS
**huronOS** is a GNU / Linux distribution **specialized in competitive programming** and all the activities around it, like official contests, training camps, practice contests or tests.

## What is different with huronOS?
huronOS is designed to work as a **live USB** compatible with both legacy and UEFI BIOS, intended to **avoid the need to modify the hardware** provided by your educational institution; you only boot and **in a matter of seconds** you can have a **competitive programming environment** ready for a competition.

## Desktop Environment
![huronOS' Desktop Environment](assets/themed/dark/huronOS-desktop-enviroment.svg#gh-dark-mode-only)
![huronOS' Desktop Environment](assets/themed/light/huronOS-desktop-enviroment.svg#gh-light-mode-only)
huronOS' desktop environment is **a first-of-its-kind**, being designed to only **keep what's important** for the contestants: Coding, Collaborating, and No Distractions.

## Synchronization 
Competitive programming activities tend to gather a considerable amount of participants at the same venue, either competing individually or as a team. This will entail the proper configuration of the programming environment to be used in such activities. That's why huronOS is built with **synchronization in mind**. huronOS is capable of synchronizing with network-directives that set the **behavior** of the system (like the **software**) to 'enabled' for the contestants, the **firewall** setup, the **wallpapers**, the **auto mounting** rules for external devices, the **timezone**, the **keyboard layouts**, etc. Everything is **remotely controlled** and applied to all instances configured with those directives.

## Training camps
In a **situation as complex** as a training camp, where each day entails different activities for which each has its own needs, huronOS **meets every need** halfway by **creating controlled environments** for when its needed, while **keeping all the information** created during the non-strict activities of the event. For example, you can compile code during your learning session and huronOS will **safely remove those files from the user filesystem** during a competition segment of the day, in order to avoid cheating and so, and by the end of this segment you can **easily regain access** to both the learning session files AND the competition ones. This can be implemented to a wide variety of events each with their own needs. 

## Execution modes
The flexibilities of huronOS (above explained) are provided as ***execution mode*** features that enable you to arrange **multiple contests** at different moments and limit them by time and date, so once a contest mode starts, huronOS knows that the whole **filesystem** needs to be **clean** and ready for an **isolated environment** for the competition. This way you don't need to clean the devices for every contest.

## Double persistence
huronOS also has a **persistence** module for **each** execution mode, like an **event** such as training camps and the **contests** that could live inside a training camp. This allows to have a persistent drive for all the code built during the learning segment, but as soon as the contest starts, the event data will be **unaccessible** for the contestant and after the contest finishes, the code of the contest can be copied to the event drive, ready for **upsolving**, and continue the learning while accumulating all the previous changes. 

## Quick Setups
All these features enable **site managers** to **quickly change** the setup of their huronOS instances to arrange an **IOI-like** contest with certain software requirements for today, and then an **ICPC-like** contest for tomorrow without the need to worry about preparing everything beforehand.