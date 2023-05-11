---
sidebar_position: 6
---
# Customizing the huronOS ISO
There are many reasons to why someone would like to customize an huronOS immutable ISO. Some of the ideas could be changing the default root password, the default wallpaper, the default directives to fallback, or even the behavior of the sync manager.

To customize huronOS' ISO, you have 2 options: To create a system layer (`.hsl`) with only your delta changes, or to build the system on your own by modifying the huronOS repositories. In this page we will only cover the first option, so, for the second option please refer to the [how to create a build](../development/how-to-create-a-build.md) page.

## Creating an huronOS system layer
To understand what a system layer is, we recommend you first read about what the *Union Filesystems* are, and what an *SquashFS* file is. These are concepts necessary to build the confidence up on creating this system layer.  
Once you're familiarized with such concepts, it's recommended to read about [how the system layers work](../internals/system-layers.md) to better understand how those ideas are used inside huronOS.  

After learning those topics, please select which files do you want to include in the new system layer, these are regularly the deltas between the layer `04-shared-libs.hsl` and the state you want to archive. In certain cases it is better to just use `savechanges` and then remove all the unnecessary files. Other times it's a better option to create a fake-root and only include the files you want. This last option is considered to be a better practice, as you have more control of what you want to include or not.  

Some examples on how to use the first method are available at [the software scripts](../../software-modules/).

## Add your system layer to the ISO
To add your own system layer to the ISO of huronOS you will need to unpack the ISO and then repack it with your added contents. To do this, you will need the [make-iso.sh](../../base-system/tools/make-iso/make-iso.sh) utility.

Create a directory with the following structure inside of it:
```txt
dir/
├── iso-data/
└── make-iso.sh
```

Now, copy all the contents of the ISO image you used to modify huronOS.
```bash
mkdir -p /media/iso
mount huronOS-b2023.0023-amd64.iso /media/iso

mkdir -p ./test-lab/iso-data
cp -rf /media/iso/* ./test-lab/iso-data/
```

After copying the content to `iso-data/`, add your custom files to the image, either `.hsl` files on the `huronOS/base/` directory or `.hsm` modules on `huronOS/software/`.

Then, configure the `make-iso.sh` script by opening it with an editor and edit the following variables:
```bash
ISO_DATA=""	# Where the ISO data will be taken from, e.g. ./iso-data
ISO_TOOL="" # The tool for making the ISO, must be on PATH. e.g. mkisofs
ISO_OUTPUT="" # How the resulting ISO will be named
CHECKSUMS="./checksums" # Leave it as it is
EFI_DIR="./EFI" # Leave it as it is
BOOT_DIR="./boot" # Leave it as it is
HURONOS_DIR="./huronOS" " # Leave it as it is
```

Finally, run the script with `./make-iso.sh`. Please make sure to give execute permissions to the file. As a result, you would've generated it with an ISO file at the output path you configured and a `.sha256` checksum file.

> **Note:** For the installer to work properly, the ISO file must be created with the `make-iso.sh` tool, as this tool calculates the checksums for all the contents of the ISO, which are then needed by the installer to validate that the installation is successfully performed.