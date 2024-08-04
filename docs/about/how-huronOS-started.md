---
sidebar_position: 1
---

# How the Project Started

huronOS have had several stages that lead to the creation of the system.

### The need for a solution
Most universities which host ICPC or IOI competitions needs to have a contest environment that's prepared and compliant with all the contest rules. This objective is hard to archive for some institutions and most of them create temporal solutions to the problematic, like Virtual Machine images, live USBs, PXE boot systems, temporarily installed OS's, or even save the data before a competition and be able to restore it after the contest to have a training camps scenario. 

The Superior School of Computer Sciences (ESCOM-IPN) was not an exception to this. The team in charge of the ICPC environment created something they called 'contestImage', which was a simple Ubuntu live USB with persistence added to it.  
They quickly noticed that in order to provide a clean environment they were needing to flash each USB (some times more than 70 USBs) for every round of the competition, which was very time consuming and did not provide as way to do a classic 'warmup' contest before the start of the competition without contaminating the filesystem with code programmed before competition.

Very quickly, the team discovered they wanted to automate several things: The setup of a wallpaper, the cleanup of the filesystem, the ability to change the firewall from a practice online judge to an official competition judge, the ability to enable or disable software depending on the type of competition (IOI-like or ICPC-like), etc.

Some of this were able to be automated, like the wallpaper and a minimal-working script to clean the filesystem. However, it was quickly noted that the effort to achieve all those features was not going to be small.

### The proof of concept
After the experience of having hosted several ICPC and OMI competitions, the team noticed that they were not alone in their experience for setting up a competitive programming contest environment. Several other universities experience the same issues, and most of them does not communicate their issues neither share their solutions. 

This led to the idea of creating a full well-crafted solution for this problematic, and use the time and effort of all this persons who already invested their time into setting up an arena for the contest to also contribute to the project. However, to do this, it was firsly required to proof that the features were actually possible to implement. Main challenges were: *How to enable and disable software on-demand in order to comply with several competitions?*, *How to make the OS immutable so that all the changes that a contestant make are able to be erased, while also preserving persistence during any competitions?*, or *How to provide persistence of data for a training camp scenario but hide it and make it unaccessible to the contestants each time a contest is held during a training camp*.

All of this ideas, made the project to be chosen as the graduation project of several students that participated into competitive programming competitions. The goal was to proof that all of these scenarios were possible by building a custom OS (distro). All these students were part of the ESCOM's algorithmic club, which official pet is a *ferret* or ***hurón*** in spanish.
This is how the project started it's implementation and got called huronOS, in alution to the pet of their club.


### The current project
After the graduation project was finished, a working *Proof Of Concept* product was available. However it still had several issues to be addressed before being able to be used by official competitions. In spite of that, at the beggining of 2022 several universities on Mexico City which were meant to be hosts for the ICPC competition, got a student strike that made the contest unable to be held by any of them. This lead another university to host the competition, with the restriction of not being able to modify the computers and to only have access to them the same day the competition. So, due to this situation huronOS was the best option available.

After the successful official contest, the team decided to made the first release, huronOS Queue 0.1 (alpha). Since then, the project has progressed tremendously and it's currently very stable and used by several organizations for their contests. However, there's still several features and characteristics typical of most other distributions that are not currently present in huronOS. For this reason, the project is still considered *alpha*.

Currently, the system is already being used at several universities and it's also the official operating system for the Mexican Olympiad of Informatics. The project is still un active development and looks forward into getting their first official release (non-alpha).