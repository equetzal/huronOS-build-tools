# huronOS history
huronOS starts its development by Enya Quetzalli in 2019 as a prototype of a distribution for competitive programming.

Why huronOS was needed in first place
In 2019 Quetzalli wanted to help her university hosts the early classificatory contests (4 contests) for the ICPC by doing coordination, logistics and learn how to configure the programming environment required for the contest. A lot of problems surged during the programming environment process because the university was not allowing the installation of any operating system on the institution hardware, any modifications were available to be done during the weekdays.

1st contest: The first contest used a virtual machine image under the supposition that all the university computed had the VM software installed, this was not true, and results were poor and not equal for all the teams.

2nd contest: On the second contest, the computers had a GNU/Linux distribution installed, but this was not complying with all the ICPC requirements.

After all of this, Quetzalli proposed preparing live-USB systems to hold the contest. This was the seed for the development of huronOS.

The Contest Image
After accepting the challenge, Quetzalli decided to build a simple image of a persistent live system by taking Ubuntu Budgie, making it persistent using Rufus utility and then install ICPC software, a basic firewall and setting a shared wallpaper for the image. Took dd and got a full image of the USB and then flashed that image on all the USBs.

3rd contest: During the third contest, some computers were using legacy BIOS, but the sticks prepared were only capable of booting on UEFI. Luckily enough there was enough UEFI computers to successfully boot a computer for all the teams. The performance of the system during the contest were good, it proved being a good a approach to be taken.

After this contest, some improvements were notable. It was needed to create a script to automatically update the wallpapers and clean all the persistent data left by the contestants on the USB keys. This led to an improved image with some scripts that connected to a server to download the current wallpaper and check for a time to clean all the contest data. This new image was called contestImage.

4th contest: After re-flashing all the USB keys for the contest and just a day before the contest, it was informed that the server where the online judge was going to be hosted was different to the stated before. This was a big problem as the firewall was configured with a different address. The contest image had hardcoded the server address, so it was needed to rebuild that image and re-flash all USBs keys again. The contest was successful, but a lot of work had to be done with pressure because of this situation.

The 4th date was important to determine that a lot of improvements were needed to cut the amount of time spent into configuring these systems, but the approach was right.

The OMI: After all the ICPC, the university was selected to be the Mexican Olympiad of Informatics finals host. But the requirements, configurations and software for this contest were highly different than the ones prepared for the ICPC. This required again, rebuilding an image for changing the software, firewall, configs, etc.

The training camp: During the first winter training camp of the university, the contest image was used for the contests on the event, but it was not possible to use it during the learning sessions as it had a firewall and restrictions that was not allowing the participants to use internet, etc.

The Proof of Life
After a year of seeing all this issues, other communities were asked if they had similar issues during the organization of their competitions and they told they had them. So, Quetzalli asked herself, why not to build a definite solution to this. An OS capable of changing its behavior and be orchestrated from a server. A lot of specialized features were needed, like:

The OS should synchronize with a server to change its behavior, allowing to be orchestrated up to N instances of the OS remotely.
Build a live system that can boot from most hardware used at universities to host competitive programming events.
Enabling and disabling software remotely in a matter of seconds.
Changing its behavior in timed schedules depending on the event running (training camps, or contests, etc.).
Cleaning its own filesystem to restore its state depending on the event running while preserving the persistence of each event running.
Change the firewall configurations according to the specifications of the running event.
Change details like wallpaper, keyboard layout, language, bookmarks, etc.
This was the start of huronOS idea, a GNU/Linux distribution based on Debian and using the Linux-Live + Slax building tools as the base for building a proof of life with all the features needed and using this project as the final project for graduation.

In 2021 the project was approved to be used for the graduation of three students:

Abraham Omar
Bryan Enrique
Enya Quetzalli
During 2021 and 2022 the project was developed, and the first builds of huronOS came to the light, showing that it was possible to satisfy most of the needs for competitive programming contests.

The First Alpha
After the final project at the university, the huronOS project is continuing its path and bringing the PoL into an alpha state for development.