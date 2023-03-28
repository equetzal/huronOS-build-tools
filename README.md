# huronOS-build-tools

This repository contain the build scripts for the GNU / Linux distribution huronOS, which can be downloaded on [huronos.org](https://huronos.org).

### Context

huronOS is a GNU / Linux distribution fully designed for [competitive programming](https://en.wikipedia.org/wiki/Competitive_programming) sport and all it's related activities. This means, that huronOS is designed to be used in such cases like:

- [ICPC](https://icpc.global) competitions
- IOI and it's classificatory competitions
- Training camps
- Training competitions

Because of this, huronOS is a very **specific-purpose** distro, and it is designed to work synchronously with a [directives file]() which specify it's behavior at any given moment. So it is **not** recommended to use huronOS as a personal use distro, but for machines that will be used by competitive programming contestants.

For this reason, huronOS is only able to be installed on **USB drives**. This is by design, so that you can run the system without modifying any hardware provided by schools or universities _(Usually competitive programming is run and supported by educational institutions, and it's competitors usually need to rely on their school provided hardware, which they're not allowed to modify)_

## How is huronOS built

huronOS is based on Debian, but it apply downstream and upstream changes that completely changes the behavior of the system. <br>
It is also modular and layer designed, meaning that for building the system, you'll be needing to build several huronOS-system-layers (or `.hsl` files), which later will be stacked during boot using a [Union File System](https://en.wikipedia.org/wiki/Union_mount).

Currently, the system uses this layers:

```txt
04-shared-libs.hsl
03-budgie.hsl
02-firmware.hsl
01-base.hsl
```

This was made on purpose, so that huronOS core is immutable even if persistence is provided. This also makes easier the updates and the software manipulation.

### Building huronOS

To build huronOS, please check the [build](./doc/development/how-to-create-a-build.md) file for detailed instructions.

### Releases

huronOS has already completed it's **Proof Of Concept** stage on 2019, has just finished the **Proof Of Life** on 2022, and it's just starting the first public alpha releases. So please, consider huronOS a non-stable distribution for now. Even if it's already usable, it still very far away of all the features it have planed.

So, if you want to use huronOS, it's recommended to keep looking for newer versions and report all the issues you encounter.

### Milestones

- [x] Finish the Proof Of Life
- [x] Make huronOS publicly configurable.
- [ ] Modularize huronOS sync services
- [ ] Create self-contained installer
- [ ] Support directives server code-rooms
- [ ] Support directives room redirection (join bigger room)
- [ ] Create a system-update tool
- [ ] Start our own apt repository
- [ ] Migrate sync modules into `.deb` packages
- [ ] Create the huronOS Package Manager (hpm) for `.hsm` modules
- [ ] Support remote software updates with hpm
- [ ] Create a status API for monitoring huronOS instances on the directives server.

#### Wished features

- [ ] Add a compatibility layer with Maratona Linux
- [ ] Add a remote monitoring package

### Contribute

Please, try the distro by yourself, learn how the directives work, and play with them and the system. Testing and trying features will help the distro become more stable.
If you want new features please open an issue.

To contribute with source code, you can submit pull request, and if you want to become a main developer, please contact me directly.

Other ways to help, is via donations, with you can do using Github Sponsors, clicking on the sponsor button on this repository. Donations helps to pay the huronOS servers, the testing computers, USB memories to play with and helps to boost the development.

### Special Thanks

- Thanks to Alvaro for all the donations to the project.
- Thanks to Daniel Cerna for all the testing being performed on this tools.
