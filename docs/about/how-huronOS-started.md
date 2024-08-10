---
sidebar_position: 1
---

# How the Project Started

huronOS has undergone several stages leading to its development as a comprehensive system.

### The Need for a Solution
Universities hosting ICPC or IOI competitions require a contest environment that is meticulously prepared and compliant with all contest rules. Achieving this goal can be challenging for many institutions, leading to temporary solutions such as Virtual Machine images, live USBs, PXE boot systems, temporary OS installations, or manually saving and restoring data before and after competitions to facilitate training camps.

The Superior School of Computer Sciences (ESCOM-IPN) faced similar challenges. The team responsible for the ICPC environment developed a solution known as 'contestImage,' a simple Ubuntu live USB with persistence. However, they quickly realized that to maintain a clean environment, they needed to flash each USB (sometimes over 70) before every competition round. This process was time-consuming and did not allow for a traditional 'warmup' contest without contaminating the filesystem with pre-competition code.

The team identified several areas for automation: setting up wallpapers, cleaning the filesystem, switching firewalls between a practice online judge and an official competition judge, enabling or disabling software based on competition type (IOI-like or ICPC-like), and more.

While some automation was achieved, such as wallpaper setup and a basic script for filesystem cleanup, it became apparent that implementing all desired features would require significant effort.

### The Proof of Concept
After hosting multiple ICPC and OMI competitions, the team recognized that their experience with setting up a competitive programming contest environment was not unique. Many other universities faced similar challenges but lacked communication or collaboration on solutions.

This realization led to the idea of creating a well-crafted, comprehensive solution to these challenges, leveraging the efforts of those who had already invested time in setting up contest arenas. However, before this could be achieved, a proof of concept was needed to demonstrate the feasibility of implementing the desired features. The main challenges included: *How to enable and disable software on-demand to comply with various competitions?*, *How to make the OS immutable so that all changes made by contestants can be erased while preserving persistence during competitions?*, and *How to provide data persistence for training camps while hiding and restricting access to contestants during contests?*

These ideas culminated in the project being selected as the graduation project for several students involved in competitive programming. Their goal was to prove that these scenarios were achievable by building a custom OS (distribution). These students were members of ESCOM's algorithmic club, whose official mascot is a *ferret*, or ***hurón*** in Spanish, which inspired the name huronOS.

### The Current Project
After completing the graduation project, a working *Proof of Concept* was available. However, it still had several issues that needed to be addressed before it could be used in official competitions. Despite these challenges, at the beginning of 2022, several universities in Mexico City that were supposed to host the ICPC competition experienced a student strike, making it impossible for them to hold the contest. Another university stepped in to host the competition, but with the restriction of not modifying the computers and having access to them only on the day of the competition. In this scenario, huronOS proved to be the best available option.

Following the successful contest, the team decided to release the first version, huronOS Queue 0.1 (alpha). Since then, the project has made significant progress and is now stable enough to be used by several organizations for their contests. However, huronOS still lacks certain features and characteristics common in other distributions, which is why it is still considered *alpha*.

Currently, huronOS is used by several universities and is the official operating system for the Mexican Olympiad of Informatics. The project remains under active development, with the team aiming for the first official (non-alpha) release.
