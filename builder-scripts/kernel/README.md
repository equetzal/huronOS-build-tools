## Kernel Builder

This set of scripts it's made to build the huronOS-configured Linux kernel.
It must have to be run on a newly installed Debian 11 Bullseye minimal installation distribution with apt configured and wired network access.

### Usage
Create a temporary directory to download this repository. 
```
cd ./kernel-builder
sudo ./build-kernel.sh
```

### Result
You'll have your kernel package compiled with all it's modules on `/linux-*-huronos.tar.gz`. 
If you want to install the compiled kernel, run `make install` inside the downloaded kernel directory. 
When you feel ready to remove all the compiled files as well as your previous kernel, just run `./clean.sh`
